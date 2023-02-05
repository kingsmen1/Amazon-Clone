const { Product } = require("../models/productModel.js");
const User = require("../models/User.js");
const Order = require("../models/orderModel");
const { catchAsync } = require("../utils/catchAsync");
const AppError = require("../utils/appError");

exports.addAddress = catchAsync(async (req, res) => {
  const { address } = req.body;
  if (!address) {
    return next(new AppError("Please Provider Address.", 400));
  }

  const user = await User.findByIdAndUpdate(
    req.user._id,
    { address: address },
    { new: true, runValidators: true }
  );

  res.status(200).json(user);
});
exports.order = catchAsync(async (req, res) => {
  const { cart, totalPrice, address } = req.body;
  let products = [];
  for (let i = 0; i < cart.length; i++) {
    let product = await Product.findById(cart[i].product._id);
    if (product.quantity >= cart[i].quantity) {
      product.quantity -= cart[i].quantity;
      products.push({ product, quantity: cart[i].quantity });
      await product.save();
    } else {
      res.status(400).json({ msg: `${product.name} is out of stock!` });
    }
  }
  const userId = req.user._id.toString();
  console.log({ user: userId });
  let user = req.user;
  user.cart = [];
  await user.save();
  let order = new Order({
    products,
    totalPrice,
    address,
    userId: userId,
    orderedAt: new Date().getTime(),
  });
  order = await order.save();
  res.status(200).json(order);
});

exports.getOrders = catchAsync(async (req, res) => {
  const userId = req.user._id.toString();
  const orders = await Order.find({ userId: userId });
  res.json(orders);
});
