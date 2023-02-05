const jwt = require("jsonwebtoken");
const { promisify } = require("util");
const { catchAsync } = require("../utils/catchAsync");
const User = require("../models/User");

const auth = catchAsync(async (req, res, next) => {
  const token = req.header("x-auth-token");
  if (!token)
    return res.status(401).json({ msg: "No auth token! access denied" });
  const decoded = await promisify(jwt.verify)(token, process.env.JWT_SECRET);
  const user = await User.findById(decoded.id);
  if (!user) return res.status(401).json({ msg: "No user with this id " });
  req.user = user;
  req.token = token;
  next();
});

module.exports = auth;
