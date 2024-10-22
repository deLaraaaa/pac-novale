import admin from "firebase-admin";
import serviceAccount from "./pac-novale-firebase-adminsdk-tqjpv-de30d8575e.json" assert { type: "json" };

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

export default db;