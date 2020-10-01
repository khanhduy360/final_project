import 'dart:async';

class AdminController {
  StreamController _revenue = new StreamController();
  StreamController _users = new StreamController();
  StreamController _order = new StreamController();
  StreamController _products = new StreamController();
  StreamController _brands = new StreamController();
  StreamController _sales = new StreamController();

  Stream get revenueStream => _revenue.stream;
  Stream get userStream => _users.stream;
  Stream get oderStream => _order.stream;
  Stream get productStream => _products.stream;
  Stream get brandStream => _brands.stream;
  Stream get saleStream => _sales.stream;

  void dispose() {
    _revenue.close();
    _users.close();
    _order.close();
    _products.close();
    _brands.close();
    _sales.close();
  }
}
