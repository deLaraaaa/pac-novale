import express from "express";
import bodyParser from "body-parser";
import cors from "cors";
import mongoose from "mongoose";

// Inicializa o app
const app = express();
app.use(bodyParser.json());
app.use(cors());

// Conectando ao MongoDB (você pode usar outra base de dados)
mongoose.connect('mongodb://localhost:27017/business', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
});

// Modelo da Empresa
const CompanySchema = new mongoose.Schema({
    name: String,
    cnpj: String,
    businessMarket: String,
    businessInnovation: String,
    businessStatus: String,
    entryDate: Date,
    exitDate: Date,
});

const Company = mongoose.model('Company', CompanySchema);

// Rota para criar uma empresa
app.post('/companies', async (req, res) => {
    const data = req.body;

    try {
        const company = new Company(data);
        await company.save();
        res.status(201).send(company);
    } catch (err) {
        res.status(400).send(err);
    }
});

// Rota para listar as empresas
app.get('/companies', async (req, res) => {
    try {
        const companies = await Company.find({});
        res.status(200).send(companies);
    } catch (err) {
        res.status(500).send(err);
    }
});

// Inicializa o servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});