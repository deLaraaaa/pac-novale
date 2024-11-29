import admin from "firebase-admin";
import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";
import fs from "fs";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({ path: path.resolve(__dirname, '../.env') });

const serviceAccountKey = process.env.FIREBASE_SERVICE_ACCOUNT_KEY;

const serviceAccount = JSON.parse(serviceAccountKey);
console.info("firebase-config.js | FTH.RL.11 | ", serviceAccountKey);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

export default db;