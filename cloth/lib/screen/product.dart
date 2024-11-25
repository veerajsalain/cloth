import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'list.dart'; // Ensure CartList is imported

class Product {
  final int id;
  final String title;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      image: json['image'],
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();

  
  static List<Product> products = [];
}

class _ProductPageState extends State<ProductPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (ProductPage.products.isEmpty) {
      fetchProducts();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://fakestoreapi.com/products');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> productData = json.decode(response.body);
        setState(() {
          ProductPage.products = productData.map((data) => Product.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching products: $e');
    }
  }

  bool isInCart(Product product) {
    return CartList.cart.any((item) => item.id == product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductPage.products.isEmpty
              ? const Center(child: Text('No products available'))
              : ListView.builder(
                  itemCount: ProductPage.products.length,
                  itemBuilder: (context, index) {
                    final product = ProductPage.products[index];
                    return buildProductCard(product);
                  },
                ),
    );
  }

  Card buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(
          product.image,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
        title: Text(product.title),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: isInCart(product)
            ? IconButton(
                icon: const Icon(Icons.remove_shopping_cart, color: Colors.red),
                onPressed: () {
                  setState(() {
                    CartList.removeFromCart(product); // Remove from cart
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.title} removed from cart!')),
                  );
                },
              )
            : IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  setState(() {
                    CartList.addToCart(product); // Add to cart
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.title} added to cart!')),
                  );
                },
              ),
      ),
    );
  }
}
