import express from "express";
import cors from "cors";
import db from "./firebase-config.js";

const app = express();
app.use(express.json());
app.use(cors());

const counterRef = db.collection('metadata').doc('counters');
const companyRef = db.collection('companies');

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
        res.status(201).json({ message: 'Empresa criada com sucesso', id: newCompanyId });
    } catch (err) {
        res.status(400).send({ error: 'Erro ao criar empresa', details: err.message });
    }
};

const getCompanies = async (req, res) => {
    try {
        const snapshot = await companyRef.where('Activate', '==', true).get();
        const companies = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        res.status(200).json(companies);
    } catch (err) {
        res.status(500).send({ error: 'Erro ao buscar empresas', details: err.message });
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
        res.status(500).send({ error: 'Erro ao desativar empresa', details: err.message });
    }
};

const updateCompany = async (req, res) => {
    const { id, field, value } = req.body;

    if (!id || !field || value === undefined) {
        return res.status(400).send({ error: 'ID, campo e valor são obrigatórios' });
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
        res.status(500).send({ error: 'Erro ao atualizar empresa', details: err.message });
    }
};

const getEngagements = async (req, res) => {
    const { companyId, startDate, endDate } = req.body;

    if (!companyId || !startDate || !endDate) {
        return res.status(400).send({ error: "Todos os campos são obrigatórios" });
    }

    console.log(
        `Fetching engagements for companyId: ${companyId}, startDate: ${startDate}, endDate: ${endDate}`
    );

    try {
        const engagementsRef = db
            .collection("companies") // Certifique-se de que "companies" é o nome correto da sua coleção
            .doc(companyId)
            .collection("engagement");

        console.log("Engagements reference created");

        const snapshot = await engagementsRef
            .where("monthYear", ">=", startDate)
            .where("monthYear", "<=", endDate)
            .get();

        console.log(`Snapshot size: ${snapshot.size}`);

        let newClients = 0;
        let lostClients = 0;
        let prospectedClients = 0;

        snapshot.forEach((doc) => {
            const data = doc.data();
            console.log(`Found engagement: ${JSON.stringify(data)}`);
            newClients += data.newClients || 0;
            lostClients += data.lostClients || 0;
            prospectedClients += data.prospectedClients || 0;
        });

        res.status(200).json({
            newClients,
            lostClients,
            prospectedClients,
        });
    } catch (err) {
        console.error("Erro ao buscar engajamentos:", err);
        res.status(500).send({ error: "Erro ao buscar engajamentos", details: err.message });
    }
};

const createEngagement = async (req, res) => {
    const { companyId, monthYear, newClients, lostClients, prospectedClients } = req.body;

    if (
        !companyId ||
        !monthYear ||
        newClients === undefined ||
        lostClients === undefined ||
        prospectedClients === undefined
    ) {
        return res.status(400).send({ error: "Todos os campos são obrigatórios" });
    }

    try {
        const engagementRef = db
            .collection("companies") // Certifique-se de que "companies" é o nome correto da sua coleção
            .doc(companyId)
            .collection("engagement")
            .doc(monthYear.replace("/", "-"));

        await engagementRef.set({
            newClients: Number(newClients),
            lostClients: Number(lostClients),
            prospectedClients: Number(prospectedClients),
            timestamp: new Date(),
        });

        res.status(201).json({ message: "Engajamento criado com sucesso" });
    } catch (err) {
        console.error("Erro ao criar engajamento:", err);
        res.status(500).send({ error: "Erro ao criar engajamento", details: err.message });
    }
};

initializeCounter().then(() => {
    app.post('/create_companies', createCompany);
    app.get('/get_companies', getCompanies);
    app.delete('/delete_company', deleteCompany);
    app.put('/update_company', updateCompany);
    app.post('/get_engagements', getEngagements);
    app.post('/create_engagement', createEngagement);

    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
        console.log(`Servidor rodando na porta ${PORT}`);
    });
}).catch(err => {
    console.error('Failed to initialize counter:', err);
});