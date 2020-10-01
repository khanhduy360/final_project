import 'src/views/HomePage/Admin/Coupon/admin_coupon_view.dart';
import 'src/views/HomePage/Admin/OrderAndSold/admin_bill_history_view.dart';
import 'src/views/HomePage/Admin/Products/product_adding_view.dart';
import 'src/views/HomePage/Admin/Products/product_manager_view.dart';
import 'src/views/HomePage/Admin/Users/admin_user_manager.dart';
import 'src/views/HomePage/Admin/admin_home_view.dart';
import 'src/views/HomePage/Customer/CartPage/cart_view.dart';
import 'src/views/HomePage/Customer/HomePage/ProductDetail/main_detail_product_view.dart';
import 'src/views/HomePage/Customer/HomePage/cus_home_view.dart';
import 'src/views/HomePage/Customer/HomePage/product_list_view.dart';
import 'src/views/HomePage/Customer/ProfilePage/BankAccount/bank_account_view.dart';
import 'src/views/HomePage/Customer/ProfilePage/ChangePassword/change_password_view.dart';
import 'src/views/HomePage/Customer/ProfilePage/Detail/detail_user_profile_views.dart';
import 'src/views/HomePage/Customer/ProfilePage/OrderAndBill/order_and_bill_view.dart';
import 'src/views/HomePage/Customer/ProfilePage/OrderAndBill/order_history_view.dart';
import 'src/views/HomePage/Customer/ProfilePage/OrderAndBill/order_info_view.dart';
import 'src/views/HomePage/Customer/ProfilePage/profile_view.dart';
import 'src/views/HomePage/Customer/SearchPage/search_view.dart';
import 'src/views/HomePage/Customer/WishlistPage/wishlist_view.dart';
import 'src/views/HomePage/Customer/customer_home_view.dart';
import 'src/views/Register/register_view.dart';
import 'src/views/splash_view.dart';
import 'src/views/welcome_view.dart';

const initialRoute = "splash_screen";

var routes = {
  //REGISTER
  'splash_screen': (context) => SplashView(),
  'welcome_screen': (context) => WelcomeScreen(),
  'register_screen': (context) => RegisterView(),

  //ADMIN HOME VIEW
  'admin_home_screen': (context) => AdminHomeView(),
  'admin_home_product': (context) => ProductManager(),
  'admin_home_product_adding': (context) => ProductAddingView(),
  'admin_user_manager': (context) => UserManagerView(),
  'admin_coupon_manager': (context) => CouponAdminView(),
  'admin_bill_history_screen': (context) => AdminBillHistoryView(),

  //CUSTOMER HOME VIEW
  'customer_home_screen': (context) => CustomerHomeView(),
  'customer_home_page': (context) => CustomerHomePageView(),
  'customer_search_page': (context) => SearchView(),
  'customer_wishlist_page': (context) => WishListView(),
  'customer_cart_page': (context) => CartView(),
  'customer_profile_page': (context) => ProfileView(),
  'customer_detail_banner_screen': (context) => ProductListView(),
  'customer_detail_product_screen': (context) => MainDetailProductView(),
  'customer_order_history_screen': (context) => OrderHistoryView(),

  // Profile
  'customer_change_password_screen': (context) => ChangePasswordView(),
  'customer_detail_screen': (context) => DetailProfileView(),
  'custommer_bank_account_screen': (context) => BankAccountView(),
  'customer_order_detail_screen': (context) => OrderAndBillView(),
  'customer_order_info_screen': (context) => OrderInfoView(),
};
