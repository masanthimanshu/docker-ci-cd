import cors from "cors";
import express from "express";
import * as route from "./routes/export.js";

const app = express();
const PORT = process.env.PORT || 5500;

app.use(cors());
app.use(express.json());

app.use("/auth", route.authRoutes);
app.use("/user", route.userRoutes);

app.get("/health", (req, res) => res.send({ message: "It's Working!" }));

app.listen(PORT, () => console.log(`App running on http://localhost:${PORT}`));
