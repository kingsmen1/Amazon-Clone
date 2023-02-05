const Order = require("../models/orderModel");
const { catchAsync } = require("../utils/catchAsync");

exports.analytics = catchAsync(async (req, res) => {
  const orders = await Order.find({});
  let totalEarnings = 0;
  for (let i = 0; i < orders.length; i++) {
    for (let k = 0; k < orders[i].products.length; k++) {
      totalEarnings +=
        orders[i].products[k].product.price * orders[i].products[k].quantity;
    }
  }

  const mobileEarning = await fetchCategoryWiseProduct("Mobiles");
  const essentialsEarning = await fetchCategoryWiseProduct("Essentials");
  const appliancesEarning = await fetchCategoryWiseProduct("Appliances");
  const booksEarning = await fetchCategoryWiseProduct("Books");
  const fashionEarning = await fetchCategoryWiseProduct("Fashion");

  const earnings = {
    totalEarnings,
    essentialsEarning,
    mobileEarning,
    appliancesEarning,
    booksEarning,
    fashionEarning,
  };

  res.json(earnings);
});

//^NOTE: FOR PASSING NESTED QUERY WE HAVE TO PUT IT IN STRING
async function fetchCategoryWiseProduct(category) {
  let earnings = 0;
  let categoryOrders = await Order.find({
    "products.product.category": category,
  });
  for (let i = 0; i < categoryOrders.length; i++) {
    for (let k = 0; k < categoryOrders[i].products.length; k++) {
      earnings +=
        categoryOrders[i].products[k].product.price *
        categoryOrders[i].products[k].quantity;
    }
  }
  return earnings;
}
