import 'package:flutter/material.dart';
import 'product.dart';
import 'page.dart';
import 'add_product.dart';
//import 'list.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    const ProductPage(),
    const CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              // Navigate to AddProductPage and wait for the result
              final newProduct = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductPage(),
                ),
              );

              // Add the new product to the product list if it is valid
              if (newProduct != null && newProduct is Product) {
                setState(() {
                  ProductPage.products.add(newProduct); // Update product list
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${newProduct.title} added!')),
                );
              }
            },
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
}
