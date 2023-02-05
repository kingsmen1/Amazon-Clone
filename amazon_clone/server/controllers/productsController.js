const { catchAsync } = require("../utils/catchAsync");
const { Product } = require("../models/productModel");
const Order = require("../models/orderModel");
const AppError = require("../utils/appError");

exports.searchByName = catchAsync(async (req, res) => {
  //~search functionality using regex.
  const { name } = req.params;
  console.log(name);
  const products = await Product.find({
    name: { $regex: name, $options: "i" },
  });
  console.log(products);
  res.json(products);
});

exports.addProduct = catchAsync(async (req, res) => {
  const { name, description, images, quantity, price, category } = req.body;
  const product = await Product.create({
    name,
    description,
    images,
    quantity,
    price,
    category,
  });
  res.json(product);
});

exports.getProducts = catchAsync(async (req, res) => {
  const products = await Product.find(req.query);
  res.json(products);
});

exports.deleteProduct = catchAsync(async (req, res) => {
  const prodId = req.params.id;
  await Product.findByIdAndDelete(prodId);
  res.status(204).json({});
});

exports.rateProduct = catchAsync(async (req, res) => {
  const { id: prodId } = req.params;
  const { rating } = req.body;
  const { _id: userId } = req.user;
  // console.log({ id: prodId, rating: rating, userId: req.user._id });
  console.log(userId);
  let product = await Product.findById(prodId);

  for (let i = 0; i < product.ratings.length; i++) {
    if (product.ratings[i].userId == userId) {
      console.log({ index: i, true: "logic true" });
      //*if we find the previous user rating we delete by splice where 'i' is index , '1' is delete count
      product.ratings.splice(i, 1);
      break; //^break is to stop the for loop.
    }
  }
  const ratingSchema = {
    userId: userId,
    rating: rating,
  };
  //*push is used to add new item to list similar to add in dart.
  product.ratings.push(ratingSchema);
  product = await product.save();
  res.send(product);
});

exports.getDealOfTheDay = catchAsync(async (req, res) => {
  let products = await Product.find({});

  products = products.sort((a, b) => {
    let aSum = 0;
    let bSum = 0;

    for (let i = 0; i < a.ratings.length; i++) {
      aSum += a.ratings[i].rating;
    }

    for (let i = 0; i < b.ratings.length; i++) {
      bSum += b.ratings[i].rating;
    }
    return aSum < bSum ? 1 : -1;
  });

  res.json(products[0]);
});

exports.addToCart = catchAsync(async (req, res) => {
  const { id: prodId } = req.params;

  let product = await Product.findById(prodId);
  let user = req.user;
  if (user.cart.length == 0) {
    console.log("length is 0");
    user.cart.push({ product, quantity: 1 });
  } else {
    let isProductFound = false;
    for (let i = 0; i < user.cart.length; i++) {
      //^Always convert object '_id' to string.
      if (user.cart[i].product._id.equals(prodId)) {
        isProductFound = true;
      }
    }
    if (isProductFound) {
      let producttt = user.cart.find((productt) =>
        productt.product._id.equals(product._id)
      );
      producttt.quantity += 1;
    } else {
      user.cart.push({ product, quantity: 1 });
    }
  }
  await user.save();
  res.json(user);
});
exports.removeFromCart = catchAsync(async (req, res) => {
  const { id: prodId } = req.params;

  let product = await Product.findById(prodId);
  let user = req.user;

  for (let i = 0; i < user.cart.length; i++) {
    if (user.cart[i].product._id.equals(prodId)) {
      if (user.cart[i].quantity == 1) {
        //~splice used for removing item in array.
        user.cart.splice(i, 1);
      } else {
        user.cart[i].quantity -= 1;
      }
    }
  }

  await user.save();
  res.json(user);
});

exports.getOrders = catchAsync(async (req, res) => {
  const orders = await Order.find({});
  res.json(orders);
});

exports.updateOrderStatus = catchAsync(async (req, res) => {
  const { status } = req.body;
  const order = await Order.findById(req.params.id);
  if (!order) {
    return next(new AppError("No order by this id", 401));
  }
  order.status = status;
  await order.save();
  res.json(order);
});
