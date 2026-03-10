const express = require("express");

const app = express();
const PORT = 3000;

app.get("/api/hello", (req, res) => {
  res.json({
    message: "Hello from Cyber Tabletop Simulation API - Pipeline Test 2 Ash"
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
