const express = require("express");
const app = express();
const authRouter = require("./routes/auth");
const adminRoutes = require("./routes/adminRoutes.js");
const prodRouter = require("./routes/productsRoute");
const userRouter = require("./routes/userRoutes");

app.use(express.json());
app.use(authRouter);
app.use("/api/v1/user", userRouter);
app.use("/api/v1/products", prodRouter);
app.use("/api/v1/admin", adminRoutes);

app.use((err, req, res, next) => {
  err.statusCode = err.statusCode || 400;
  err.status = err.status || "Fail";
  res.status(err.statusCode).json({
    status: err.status,
    error: err,
    msg: err.message,
    stack: err.stack,
  });
});

module.exports = app;
