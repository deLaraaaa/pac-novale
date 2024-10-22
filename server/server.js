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
    try {
        let newCompanyId;
        await db.runTransaction(async (transaction) => {
            const counterDoc = await transaction.get(counterRef);
            if (!counterDoc.exists) {
                throw new Error('Counter document does not exist!');
            }

            newCompanyId = counterDoc.data().nextCompanyId;
            transaction.update(counterRef, { nextCompanyId: newCompanyId + 1 });

            transaction.set(companyRef.doc(newCompanyId.toString()), req.body);
        });
        res.status(201).json({ message: 'Empresa criada com sucesso', id: newCompanyId });
    } catch (err) {
        res.status(400).send({ error: 'Erro ao criar empresa', details: err.message });
    }
};

const getCompanies = async (req, res) => {
    try {
        const snapshot = await companyRef.get();
        const companies = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        res.status(200).json(companies);
    } catch (err) {
        res.status(500).send({ error: 'Erro ao buscar empresas', details: err.message });
    }
};

initializeCounter().then(() => {
    app.post('/create_companies', createCompany);
    app.get('/get_companies', getCompanies);

    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
        console.log(`Servidor rodando na porta ${PORT}`);
    });
}).catch(err => {
    console.error('Failed to initialize counter:', err);
});