const appInsightsClient = require("./insights");

const PORT = process.env.PORT || 3000;

app = require("./app");

require("./db-init");

app.listen(PORT, () => {
  console.log(` TechMart Payment API running on port ${PORT}`);
  appInsightsClient.trackEvent({
    name: "ApplicationStarted",
    properties: { port: PORT.toString() },
  });
});
