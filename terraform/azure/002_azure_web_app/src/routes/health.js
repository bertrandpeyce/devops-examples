const express = require("express");
const router = express.Router();
const poolPromise = require("../db");
const redisClient = require("../redis");
const appInsightsClient = require("../insights");

// Utilitaire timeout défini ci-dessus
function timeout(promise, ms) {
  return Promise.race([
    promise,
    new Promise((_, reject) =>
      setTimeout(() => reject(new Error("Timeout")), ms),
    ),
  ]);
}

router.get("/", async (req, res) => {
  const healthCheck = {
    uptime: process.uptime(),
    timestamp: Date.now(),
    status: "OK",
  };

  // Timeout MSSQL pool
  try {
    const pool = await timeout(poolPromise, 5000); // 5s timeout sur la connexion MSSQL
    await timeout(pool.request().query("SELECT 1"), 5000); // 5s timeout sur la requête
    healthCheck.database = "Connected";
  } catch (err) {
    healthCheck.database = "ERROR";
    healthCheck.databaseError = err.message;
  }

  // Timeout Redis ping
  try {
    await timeout(redisClient.ping(), 2000); // 2s timeout sur Redis ping
    healthCheck.cache = "Connected";
  } catch (err) {
    healthCheck.cache = "ERROR";
    healthCheck.cacheError = err.message;
  }

  // Statut global
  if (healthCheck.database === "ERROR" || healthCheck.cache === "ERROR") {
    healthCheck.status = "ERROR";
    appInsightsClient.trackMetric({ name: "HealthCheck.Failure", value: 1 });
  }

  res.status(healthCheck.status === "OK" ? 200 : 503).json(healthCheck);
});

module.exports = router;
