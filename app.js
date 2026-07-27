import cors from "cors";
import express from "express";
import * as route from "./routes/export.js";
import { collectDefaultMetrics, register } from "prom-client";

const app = express();
const PORT = process.env.PORT || 5500;

app.use(cors());
app.use(express.json());

collectDefaultMetrics({ register });

app.use("/auth", route.authRoutes);
app.use("/user", route.userRoutes);

app.get("/health", (req, res) => res.send({ message: "It's Working!" }));

app.get("/metrics", async (req, res) => {
  res.set("Content-Type", register.contentType);
  res.send(await register.metrics());
});

app.listen(PORT, () => console.log(`App running on http://localhost:${PORT}`));
