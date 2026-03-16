const express = require("express");

const app = express();
const PORT = 3000;

app.get("/api/hello", (req, res) => {
  res.json({
    message: "HHey guys lets do this - test 1"
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
