import { Router } from "express";

export const routes = Router();

routes.get("/health", (req, res) => {
  res.send({ message: "Auth route is working!" });
});
