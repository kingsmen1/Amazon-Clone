const mongoose = require("mongoose");
const ratingSchema = require("../models/ratingModel");

const productSchema = mongoose.Schema({
  name: {
    type: String,
    trim: true,
    maxlength: 25,
    required: [true, "Product must have a name"],
  },
  description: {
    type: String,
    trim: true,
    required: [true, "Product must have a description"],
  },
  images: [
    {
      type: String,
      required: true,
    },
  ],
  quantity: {
    type: Number,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  //Todo: Improve ratings by parent & child referencing.
  ratings: [ratingSchema],
});

const Product = mongoose.model("Product", productSchema);
module.exports = { Product, productSchema };
