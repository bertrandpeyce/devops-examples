const redis = require("redis");

const redisClient = redis.createClient({
  socket: {
    host: process.env.REDIS_HOST,
    port: Number(process.env.REDIS_PORT),
    tls: true, // Si tu as besoin de TLS (Azure Cache for Redis)
  },
  password: process.env.REDIS_PASSWORD,
});

// Connecte le client au démarrage
redisClient.on("error", (err) => {
  console.error("Redis Client Error", err);
});

(async () => {
  await redisClient.connect();
})();

module.exports = redisClient;
