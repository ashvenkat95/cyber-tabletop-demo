// VULNERABLE VERSION - For testing secret detection (GitLeaks)
// Copy the apiKey line into server.js to simulate pipeline failure
const express = require("express");

const app = express();
const PORT = 3000;

// INTENTIONAL VULNERABILITY - GitLeaks will detect this!
const apiKey = "12345-SECRET-KEY";

app.get("/api/hello", (req, res) => {
  res.json({
    message: "Hello from Cyber Tabletop Simulation API"
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
