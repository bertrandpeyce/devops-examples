const poolPromise = require("./db");

async function createPaymentsTable() {
  try {
    const pool = await poolPromise;
    await pool.request().query(`
      IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Payments')
      CREATE TABLE Payments (
        PaymentId INT IDENTITY(1,1) PRIMARY KEY,
        Amount DECIMAL(10,2) NOT NULL,
        Currency NVARCHAR(50) NOT NULL,
        MerchantId NVARCHAR(100) NOT NULL,
        Status NVARCHAR(20) NOT NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
      );
    `);
    console.log("Table Payments créée ou déjà existante");
  } catch (err) {
    console.error("Erreur création table:", err);
  }
}

createPaymentsTable();
