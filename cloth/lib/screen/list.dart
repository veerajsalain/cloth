import 'product.dart';

class CartList {
  static List<Product> cart = [];

  static void addToCart(Product product) {
    cart.add(product);
  }

  static void removeFromCart(Product product) {
    cart.removeWhere((item) => item.id == product.id);
  }

  static List<Product> getCartItems() {
    return List.unmodifiable(cart);
  }
}