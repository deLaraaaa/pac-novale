import db from "./firebase-config.js";

// Função para buscar todas as empresas
const fetchCompanies = async () => {
    try {
        const snapshot = await db.collection('companies').get(); // Pega a coleção de empresas
        const companies = [];
        snapshot.forEach((doc) => {
            companies.push({ id: doc.id, ...doc.data() }); // Adiciona o ID do documento junto aos dados
        });
        return companies;
    } catch (error) {
        throw new Error('Erro ao buscar empresas: ' + error.message);
    }
};

// Função para adicionar uma nova empresa
const addCompany = async (companyData) => {
    try {
        const companyRef = await db.collection('companies').add(companyData);
        return companyRef.id; // Retorna o ID da nova empresa
    } catch (error) {
        throw new Error('Erro ao adicionar empresa: ' + error.message);
    }
};

export {
    fetchCompanies,
    addCompany,
};