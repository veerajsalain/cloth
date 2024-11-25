import 'package:flutter/material.dart';
import 'product.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // For form validation

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void addProduct() {
    // Validate form before proceeding
    if (_formKey.currentState?.validate() ?? false) {
      final title = titleController.text;
      final price = double.tryParse(priceController.text);
      final image = imageController.text;

      if (title.isNotEmpty && price != null && price > 0 && image.isNotEmpty) {
        final newProduct = Product(
          id: DateTime.now().millisecondsSinceEpoch,
          title: title,
          price: price,
          image: image,
        );

        // Pop and return the new product to the previous page
        Navigator.pop(context, newProduct);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Please enter a valid price greater than 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: addProduct,
                child: const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
