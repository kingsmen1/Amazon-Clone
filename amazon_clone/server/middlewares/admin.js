const { promisify } = require("util");
const jwt = require("jsonwebtoken");
const User = require("../models/User.js");
const { catchAsync } = require("../utils/catchAsync");

exports.isAdmin = catchAsync(async (req, res, next) => {
  const token = req.header("x-auth-token");

  if (!token) {
    return res.status(401).json({ msg: "No auth token! access denied" });
  }

  const decoded = await promisify(jwt.verify)(token, process.env.JWT_SECRET);

  const user = await User.findById(decoded.id);
  if (!user) {
    return res.status(401).json({ msg: "Unauthorized! access denied" });
  }

  if (user.type === "seller" || user.type === "user") {
    return res.status(401).json({ msg: "Unauthorized! You are not admin" });
  }
  req.user = user;
  req.token = token;

  next();
});
