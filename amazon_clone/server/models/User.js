const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const { Product, productSchema } = require("./productModel");

const userSchema = mongoose.Schema({
  name: {
    type: String,
    required: [true, "Please Porvide you name"],
    trim: true,
  },
  email: {
    type: String,
    required: [true, "Please Provide you email"],
    trim: true,
    unique: true,
    validate: {
      validator(val) {
        const regex =
          /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return val.match(regex);
      },
      message: "Please enter a valid email address",
    },
  },
  password: {
    type: String,
    required: [true, "Please provider a password"],
    minlength: [6, "password must atleast of 6 characters"],
    select: false,
  },
  address: {
    type: String,
    default: "",
  },
  type: {
    type: String,
    enum: ["user", "admin", "seller"],
    default: "user",
  },
  //Todo: Improve cart by parent & child referencing.
  cart: [
    {
      product: productSchema,
      quantity: {
        type: Number,
        required: true,
      },
    },
  ],
});

userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

userSchema.methods.correctPassword = async function (
  candidatePassword,
  userPassword
) {
  return await bcrypt.compare(candidatePassword, userPassword);
};

module.exports = mongoose.model("User", userSchema);
