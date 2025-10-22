// backend/server.js
const express = require("express");
const fs = require("fs");
const path = require("path");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

const DATA_FILE = path.join(__dirname, "db.json");

// Ensure db.json exists
if (!fs.existsSync(DATA_FILE)) fs.writeFileSync(DATA_FILE, JSON.stringify({ certs: {} }, null, 2));

// Create / update a certificate
app.post("/certificates", (req, res) => {
  const { hash, name, idNumber, issueDate } = req.body;
  if (!hash || !name || !idNumber || !issueDate) {
    return res.status(400).json({ error: "missing fields" });
  }
  const db = JSON.parse(fs.readFileSync(DATA_FILE, "utf8"));
  db.certs[hash] = { name, idNumber, issueDate };
  fs.writeFileSync(DATA_FILE, JSON.stringify(db, null, 2));
  res.json({ ok: true });
});

// Read a certificate by hash
app.get("/certificates/:hash", (req, res) => {
  const db = JSON.parse(fs.readFileSync(DATA_FILE, "utf8"));
  const cert = db.certs[req.params.hash];
  if (!cert) return res.status(404).json({ error: "not found" });
  res.json(cert);
});

// Optional: friendly root
app.get("/", (_req, res) => {
  res.send("Certificate API is running. Try GET /certificates/:hash");
});

app.listen(4000, () => {
  console.log("✅ API running at http://localhost:4000");
});
