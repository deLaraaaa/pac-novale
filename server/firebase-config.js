import admin from "firebase-admin";
import serviceAccount from "./key/pac-novale2-firebase-adminsdk-6mljm-82942e928b.json" assert { type: "json" };;
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

export default db;
