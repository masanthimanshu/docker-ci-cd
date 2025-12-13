import express from "express";
import cors from "cors";

const app = express();
const PORT = process.env.PORT || 5500;

app.use(cors());
app.use(express.json());

app.get("/health", (req, res) => res.send({ status: "It's Working!!" }));

app.listen(PORT, () => console.log(`App running on http://localhost:${PORT}`));
