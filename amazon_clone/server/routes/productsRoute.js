const epxpress = require("express");
const router = epxpress.Router();
const productsController = require("../controllers/productsController");
const auth = require("../middlewares/authMiddleware");

router.use(auth);

router
  .route("/")
  .get(productsController.getProducts)
  .post(productsController.addProduct);

router.post("/rating/:id", productsController.rateProduct);
router.get("/deal-of-day", productsController.getDealOfTheDay);
router.post("/add-to-cart/:id", productsController.addToCart);
router.delete("/remove-from-cart/:id", productsController.removeFromCart);

router.route("/:id").delete(productsController.deleteProduct);
router.route("/search/:name").get(productsController.searchByName);
module.exports = router;
