import express from 'express';
import cors from 'cors';
import db from './firebase-config.js';

const app = express();
app.use(express.json());
app.use(cors());

const counterRef = db.collection('metadata').doc('counters');
const companyRef = db.collection('companies');
const engagementRef = db.collection('engagement');

const initializeCounter = async () => {
  const counterDoc = await counterRef.get();
  if (!counterDoc.exists) {
    await counterRef.set({ nextCompanyId: 1 });
  }
};

const createCompany = async (req, res) => {
  const data = { ...req.body, Activate: true };

  try {
    let newCompanyId;
    await db.runTransaction(async (transaction) => {
      const counterDoc = await transaction.get(counterRef);
      if (!counterDoc.exists) {
        throw new Error('Counter document does not exist!');
      }

      newCompanyId = counterDoc.data().nextCompanyId;
      transaction.update(counterRef, { nextCompanyId: newCompanyId + 1 });

      transaction.set(companyRef.doc(newCompanyId.toString()), data);
    });
    res
      .status(201)
      .json({ message: 'Empresa criada com sucesso', id: newCompanyId });
  } catch (err) {
    res
      .status(400)
      .send({ error: 'Erro ao criar empresa', details: err.message });
  }
};

const getCompanies = async (req, res) => {
  try {
    const snapshot = await companyRef.where('Activate', '==', true).get();
    const companies = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));
    res.status(200).json(companies);
  } catch (err) {
    res
      .status(500)
      .send({ error: 'Erro ao buscar empresas', details: err.message });
  }
};

const getInfoByType = async (req, res) => {
  const { id, type, startDate, endDate } = req.body;

  if (!id || !type || !startDate || !endDate) {
    return res
      .status(400)
      .send({ error: 'ID, tipo, startDate e endDate são obrigatórios.' });
  }

  try {
    // Referência à sub-coleção da empresa especificada
    const subCollectionRef = db
      .collection('companies') // Coleção principal
      .doc(id) // Documento específico (empresa)
      .collection(type); // Sub-coleção (tipo)

    const formattedStartDate = startDate.slice(0, 7);
    const formattedEndDate = endDate.slice(0, 7);
    // Query para buscar documentos dentro do intervalo de datas
    const snapshot = await subCollectionRef
      .where('__name__', '>=', formattedStartDate) // Nome do documento >= startDate
      .where('__name__', '<=', formattedEndDate) // Nome do documento <= endDate
      .get();

    if (snapshot.empty) {
      return res.status(404).send({
        error: `Nenhum dado encontrado para o tipo "${type}" no período especificado.`,
      });
    }

    // Mapear os documentos da sub-coleção
    const documents = snapshot.docs.map((doc) => ({
      id: doc.id, // ID único do documento
      ...doc.data(), // Dados do documento
    }));

    return res.status(200).json({ data: documents });
  } catch (error) {
    console.error('Erro ao buscar dados por tipo e período:', error.message);
    return res
      .status(500)
      .send({ error: 'Erro ao buscar dados.', details: error.message });
  }
};

const updateCompanyInfo = async (req, res) => {
  const { id, date, values, type } = req.body; // Dados enviados no corpo da requisição

  // Verificar se todos os campos obrigatórios estão presentes
  if (!id || !date || !values || !type) {
    return res
      .status(400)
      .send({ error: 'ID, date, values e type são obrigatórios' });
  }

  try {
    // Extrair ano e mês do campo `date`
    const yearMonth = date.slice(0, 7); // Assume que a data está no formato ISO "YYYY-MM-DD"

    // Referência ao documento da empresa
    const companyDocRef = db.collection('companies').doc(id);

    // Verificar se o documento existe
    const companyDoc = await companyDocRef.get();
    if (!companyDoc.exists) {
      return res.status(404).send({ error: 'Empresa não encontrada' });
    }

    // Referência à subcoleção "engagement"
    const engagementRef = companyDocRef.collection('engagement');

    // Preparar os dados a serem adicionados ou atualizados
    const newEngagement = {
      date: date,
      mentorias: values.mentorias || 0,
      cursos: values.cursos || 0,
      palestras: values.palestras || 0,
      eventos: values.eventos || 0,
    };

    // Adicionar ou atualizar o documento com o ID igual ao ano e mês
    await engagementRef.doc(yearMonth).set(newEngagement);

    // Retornar sucesso
    res.status(200).json({
      message: 'Engagement atualizado com sucesso',
      data: newEngagement,
    });
  } catch (err) {
    console.error('Erro ao atualizar o documento:', err);
    res
      .status(500)
      .send({ error: 'Erro ao atualizar engagement', details: err.message });
  }
};

const deleteCompany = async (req, res) => {
  const companyId = req.body.id;

  if (!companyId) {
    return res.status(400).send({ error: 'ID da empresa é obrigatório' });
  }

  try {
    const companyDoc = companyRef.doc(companyId);
    const doc = await companyDoc.get();

    if (!doc.exists) {
      return res.status(404).send({ error: 'Empresa não encontrada' });
    }

    await companyDoc.update({ Activate: false });
    res.status(200).json({ message: 'Empresa desativada com sucesso' });
  } catch (err) {
    res
      .status(500)
      .send({ error: 'Erro ao desativar empresa', details: err.message });
  }
};

const updateCompany = async (req, res) => {
  const { id, field, value } = req.body;

  if (!id || !field || value === undefined) {
    return res
      .status(400)
      .send({ error: 'ID, campo e valor são obrigatórios' });
  }

  try {
    const companyDoc = companyRef.doc(id);
    const doc = await companyDoc.get();

    if (!doc.exists) {
      return res.status(404).send({ error: 'Empresa não encontrada' });
    }

    await companyDoc.update({ [field]: value });
    res.status(200).json({ message: 'Empresa atualizada com sucesso' });
  } catch (err) {
    res
      .status(500)
      .send({ error: 'Erro ao atualizar empresa', details: err.message });
  }
};

initializeCounter()
  .then(() => {
    app.post('/create_companies', createCompany);
    app.get('/get_companies', getCompanies);
    app.delete('/delete_company', deleteCompany);
    app.put('/update_company', updateCompany);
    app.put('/update_companie_info', updateCompanyInfo);
    app.post('/get_info_by_type', getInfoByType);

    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
      console.log(`Servidor rodando na porta ${PORT}`);
    });
  })
  .catch((err) => {
    console.error('Failed to initialize counter:', err);
  });
