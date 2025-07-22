const express = require("express");
const helmet = require("helmet");
const rateLimit = require("express-rate-limit");
const healthRouter = require("./routes/health");
const apiPaymentRouter = require("./routes/api/payments.js");
const rootRouter = require("./routes/root.js");
const apiRouter = require("./routes/api.js");

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limite par IP
});

const app = express();

app.use(helmet());
app.use(express.json({ limit: "10mb" }));

app.use("/", rootRouter);
app.use("/health", healthRouter);
app.use("/api/", limiter);
app.use("/api", apiRouter);
app.use("/api/payments", apiPaymentRouter);

module.exports = app;
