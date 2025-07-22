const express = require("express");
const router = express.Router();

router.get("/", (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html lang="fr">
      <head>
        <meta charset="UTF-8">
        <title>✨ API Paiement Kawaii ✨</title>
        <style>
          body {
            background: #fff0f5;
            color: #ff69b4;
            font-family: 'Comic Sans MS', 'Comic Sans', cursive;
            text-align: center;
            margin: 0;
            padding: 40px 10px;
          }
          h1 {
            font-size: 2.7em;
            margin-bottom: 0.5em;
            text-shadow: 2px 2px #ffe6fa;
          }
          .kawaii {
            font-size: 3em;
            margin-bottom: 0.3em;
          }
          .endpoint {
            background: #ffe6fa;
            border-radius: 18px;
            display: inline-block;
            padding: 1em 2em;
            margin: 2em auto 2em auto;
            box-shadow: 0 2px 8px rgba(255,105,180,0.12);
          }
          .endpoint h2 {
            margin-top: 0;
            font-size: 1.5em;
            color: #e75480;
          }
          code {
            background: #fff;
            border-radius: 6px;
            padding: 2px 8px;
            color: #da70d6;
            font-size: 1.1em;
          }
          .btn {
            display: inline-block;
            margin-top: 1em;
            padding: 0.5em 1.3em;
            border-radius: 20px;
            background: #ffb6c1;
            color: #fff;
            text-decoration: none;
            font-weight: bold;
            box-shadow: 0 2px 8px rgba(255,105,180,0.10);
            transition: background 0.2s;
          }
          .btn:hover {
            background: #e75480;
          }
          .curl {
            text-align: left;
            background: #fff;
            color: #da70d6;
            font-family: 'Fira Mono', 'Consolas', monospace;
            border-radius: 12px;
            padding: 1em;
            margin: 1em 0 0.5em 0;
            font-size: 1em;
            display: inline-block;
          }
        </style>
      </head>
      <body>
        <div class="kawaii">✿ฅ^•ﻌ•^ฅ✿</div>
        <h1>Bienvenue sur l'API Paiement Kawaii !</h1>
        <p>
          Bienvenue sur l’API de paiement la plus adorable du web.<br>
          Voici la liste des endpoints disponibles&nbsp;:
        </p>
        
        <div class="endpoint">
          <h2>💸 Créer un paiement</h2>
          <p>
            <code>POST /api/payments</code>
          </p>
          <p>
            <b>Body JSON :</b><br>
            <code>{ "amount": 42.00, "currency": "EUR", "merchantId": "MERCHANT123" }</code>
          </p>
          <div class="curl">
            curl -X POST <br>
            &nbsp;&nbsp;https://<i>votre-domaine</i>/api/payments <br>
            &nbsp;&nbsp;-H "Content-Type: application/json" <br>
            &nbsp;&nbsp;-d '{"amount":42.00,"currency":"EUR","merchantId":"MERCHANT123"}'
          </div>
          <p>
            <b>Réponse :</b><br>
            <code>{ "paymentId": 1, "status": "COMPLETED", "amount": 42.00, "currency": "EUR", "processedAt": "..." }</code>
          </p>
        </div>
        <a class="btn" href="/">Retour à l’accueil kawaii</a>
        <div class="kawaii">(◕‿◕✿)</div>
      </body>
    </html>
  `);
});

module.exports = router;
