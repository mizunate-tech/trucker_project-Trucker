import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("PRODUCTS HERE")),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
