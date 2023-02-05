const express = require("express");
const router = express.Router();
const auth = require("../middlewares/authMiddleware");
const {
  addAddress,
  order,
  getOrders,
} = require("../controllers/userController");

router.use(auth);

router.post("/add-address", addAddress);
router.route("/order").post(order).get(getOrders);

module.exports = router;
