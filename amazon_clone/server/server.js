require("dotenv").config({ path: "./config.env" });
// const dotenv = require("dotenv");
const app = require("./app");
const mongoose = require("mongoose");

const port = process.env.PORT || 3000;
const DB = process.env.DATABASE.replace(
  "<PASSWORD>",
  process.env.DATABASE_PASSWORD
);

mongoose
  .connect(DB)
  .then(() => {
    console.log("Databae Connection Successful");
    app.listen(port, "0.0.0.0", () => {
      console.log(`App is listening on port:${port}`);
    });
  })
  .catch((e) => console.log(e));
