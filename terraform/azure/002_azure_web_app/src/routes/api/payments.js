appInsightsClient = require("../../insights");
const express = require("express");
const router = express.Router();
const poolPromise = require("../../db");
const sql = require("mssql");

// API Payments avec monitoring complet
router.post("/", async (req, res) => {
  const startTime = Date.now();
  const { amount, currency, merchantId } = req.body;
  try {
    // Log de la transaction
    appInsightsClient.trackEvent({
      name: "PaymentInitiated",
      properties: { merchantId, currency, amount: amount.toString() },
    });
    // Simulation traitement paiement
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input("amount", sql.Decimal(10, 2), amount)
      .input("currency", sql.NVarChar, currency)
      .input("merchantId", sql.NVarChar, merchantId).query(`
INSERT INTO Payments (Amount, Currency, MerchantId, Status, CreatedAt)
VALUES (@amount, @currency, @merchantId, 'COMPLETED', GETDATE());
SELECT SCOPE_IDENTITY() as PaymentId;
`);

    const paymentId = result.recordset[0].PaymentId;

    // Métriques de performance
    const duration = Date.now() - startTime;
    appInsightsClient.trackMetric({
      name: "PaymentProcessing.Duration",
      value: duration,
    });
    appInsightsClient.trackMetric({
      name: "PaymentProcessing.Success",
      value: 1,
    });
    res.status(201).json({
      paymentId,
      status: "COMPLETED",
      amount,
      currency,
      processedAt: new Date().toISOString(),
    });
  } catch (error) {
    const duration = Date.now() - startTime;
    appInsightsClient.trackException({
      exception: error,
      properties: { merchantId, amount: amount?.toString() },
    });
    appInsightsClient.trackMetric({
      name: "PaymentProcessing.Error",
      value: 1,
    });
    appInsightsClient.trackMetric({
      name: "PaymentProcessing.Duration",
      value: duration,
    });
    res.status(500).json({
      error: "Payment processing failed: ${error.message}",
      timestamp: new Date().toISOString(),
    });
  }
});

module.exports = router;
