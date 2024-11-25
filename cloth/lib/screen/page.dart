import 'package:flutter/material.dart';
import 'list.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartItems = CartList.getCartItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : ListView.separated(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return _buildCartItem(product);
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
    );
  }

  // Empty cart widget
  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Cart item widget
  Widget _buildCartItem(product) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: _buildProductImage(product.image),
        title: Text(product.title),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.remove_shopping_cart),
          onPressed: () {
            setState(() {
              CartList.removeFromCart(product);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.title} removed from cart!'),
              ),
            );
          },
        ),
      ),
    );
  }

  // Product image widget with error fallback
  Widget _buildProductImage(String imageUrl) {
    return Image.network(
      imageUrl,
      height: 50,
      width: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.broken_image,
          size: 50,
          color: Colors.grey,
        );
      },
    );
  }
}
