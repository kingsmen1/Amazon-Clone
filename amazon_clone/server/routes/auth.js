const express = require("express");
const User = require("../models/User");
const { catchAsync } = require("../utils/catchAsync");
const authRouter = express.Router();
const AppError = require("../utils/appError");
const jwt = require("jsonwebtoken");
const { promisify } = require("util");
const auth = require("../middlewares/authMiddleware");

authRouter.post(
  "/api/signup",
  catchAsync(async (req, res, next) => {
    const { name, email, password } = req.body;
    if (!name || !email || !password) {
      return next(new AppError("Please Provide email and password.", 400));
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with this email alreadt exist" });
    }
    const user = await User.create({
      name: name,
      email: email,
      password: password,
    });

    res.status(200).json({ user });
  })
);

function generateJwt(id) {
  return new Promise((resolve, reject) => {
    jwt.sign({ id: id }, process.env.JWT_SECRET, (err, token) => {
      if (token) {
        resolve(token);
      } else {
        reject(err);
      }
    });
  });
}
authRouter.post(
  "/api/signin",
  catchAsync(async (req, res, next) => {
    console.log("signin");
    const { email, password } = req.body;
    if ((!email, !password)) {
      return next(new AppError("Please enter email and password", 400));
    }
    const user = await User.findOne({ email }).select("+password");

    if (!user || !(await user.correctPassword(password, user.password))) {
      return next(new AppError(`Invalid Credential's`, 400));
    }
    const token = await generateJwt(user._id);
    res.status(200).json({ token, ...user._doc });
  })
);

authRouter.post(
  "/tokenIsValid",
  catchAsync(async (req, res, next) => {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const decoded = await promisify(jwt.verify)(token, process.env.JWT_SECRET);
    const user = await User.findById(decoded.id);
    if (!user) return res.json(false);
    res.json(true);
  })
);

authRouter.get("/", auth, (req, res) => {
  res.status(200).json({ ...req.user._doc, token: req.token });
});
module.exports = authRouter;
