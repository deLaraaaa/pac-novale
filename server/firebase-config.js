import admin from "firebase-admin";
import serviceAccount from "./package.json"; // Insira o caminho correto do arquivo de credenciais .json

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

module.exports = db;