const express = require("express");
const adminRouter = express.Router();
const { isAdmin } = require("../middlewares/admin");
const {
  addProduct,
  getProducts,
  deleteProduct,
  getOrders,
  updateOrderStatus,
} = require("../controllers/productsController");
const { router } = require("../app");
const { analytics } = require("../controllers/adminController");

adminRouter.use(isAdmin);

adminRouter.route("/product").post(addProduct).get(getProducts);
adminRouter.route("/product/:id").delete(deleteProduct);
adminRouter.route("/orders").get(getOrders);
adminRouter.route("/orders/:id").patch(updateOrderStatus);
adminRouter.route("/analytics").get(analytics);

module.exports = adminRouter;
