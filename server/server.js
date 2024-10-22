import express from "express";
import cors from "cors";
import { fetchCompanies, addCompany } from "./company_service.js";

const app = express();
app.use(express.json());
app.use(cors());

app.post('/companies', async (req, res) => {
    try {
        const newCompanyId = await addCompany(req.body);
        res.status(201).json({ message: 'Empresa criada com sucesso', id: newCompanyId });
    } catch (err) {
        res.status(400).send({ error: 'Erro ao criar empresa', details: err.message });
    }
});

app.get('/companies', async (req, res) => {
    try {
        const companies = await fetchCompanies();
        res.status(200).json(companies);
    } catch (err) {
        res.status(500).send({ error: 'Erro ao buscar empresas', details: err.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});