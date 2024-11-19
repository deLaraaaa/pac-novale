import admin from "firebase-admin";
import serviceAccount from "./key/pac-novale2-firebase-adminsdk-6mljm-c902412ef9.json" assert { type: "json" };

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

export default db;