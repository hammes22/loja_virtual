import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:provider/provider.dart';

class SelectProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Vincular Produto'),
        centerTitle: true,
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          return ListView.builder(
            itemCount: productManager.allProducts.length,
            itemBuilder: (_, index) {
              final product = productManager.allProducts[index];
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Image.network(product.images.first),
                    title: Text(product.name),
                    subtitle: Text(
                      'R\$ ${product.basePrice.toStringAsFixed(2)}',
                    ),
                    onTap: () {
                      Navigator.of(context).pop(product);
                    },
                  ),
                  Divider(
                      color: Theme.of(context).primaryColor,
                      )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
