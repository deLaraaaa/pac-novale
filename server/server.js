import express from "express";
import cors from "cors";
import { fetchCompanies, addCompany } from "./company_service.js"; // Use named imports

// Inicializa o app
const app = express();
app.use(express.json()); // Já vem no express, então body-parser é desnecessário
app.use(cors()); // Permite requisições cross-origin

// Rota para criar uma empresa
app.post('/companies', async (req, res) => {
  try {
    const newCompanyId = await addCompany(req.body); // Adiciona empresa no Firestore
    res.status(201).json({ message: 'Empresa criada com sucesso', id: newCompanyId }); // Envia o ID da nova empresa
  } catch (err) {
    res.status(400).send({ error: 'Erro ao criar empresa', details: err.message });
  }
});

// Rota para listar as empresas
app.get('/companies', async (req, res) => {
  try {
    const companies = await fetchCompanies(); // Busca as empresas no Firestore
    res.status(200).json(companies); // Envia as empresas no formato JSON
  } catch (err) {
    res.status(500).send({ error: 'Erro ao buscar empresas', details: err.message });
  }
});

// Inicializa o servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});