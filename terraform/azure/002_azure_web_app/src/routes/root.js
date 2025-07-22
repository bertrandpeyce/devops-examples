const express = require("express");
const router = express.Router();

router.get("/", (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html lang="fr">
      <head>
        <meta charset="UTF-8">
        <title>Bienvenue ✨</title>
        <style>
          body {
            background: #ffe6f2;
            font-family: 'Comic Sans MS', 'Comic Sans', cursive;
            color: #ff69b4;
            text-align: center;
            padding: 40px;
          }
          h1 {
            font-size: 2.5em;
            margin-bottom: 0.3em;
            text-shadow: 2px 2px #fff0f5;
          }
          .links {
            margin-top: 2em;
          }
          a {
            display: inline-block;
            margin: 0 1em;
            padding: 0.5em 1.5em;
            border-radius: 25px;
            background: #fff0f5;
            color: #ff69b4;
            text-decoration: none;
            font-weight: bold;
            box-shadow: 0 2px 8px rgba(255,105,180,0.1);
            transition: background 0.2s;
          }
          a:hover {
            background: #ffb6c1;
          }
          .kawaii {
            font-size: 3em;
            margin: 0.5em;
          }
        </style>
      </head>
      <body>
        <div class="kawaii">(✿◠‿◠)</div>
        <h1>Bonjour et bienvenue sur le site de paiement en ligne !</h1>
        <p>
          Découvrez la magie du paiement kawai 🌸.<br>
          Vous pouvez vérifier la santé du service sur <a href="/health">/health</a>.<br>
          Pour voir la liste des API disponibles, rendez-vous sur <a href="/api">/api</a>.
        </p>
        <div class="kawaii">ฅ^•ﻌ•^ฅ</div>
      </body>
    </html>
  `);
});

module.exports = router;
