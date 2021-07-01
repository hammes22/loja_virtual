import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:provider/provider.dart';

class DeleteItemSize extends StatelessWidget {
  const DeleteItemSize(this.product);

  final Product product;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Deletar ${product.name}?'),
      content: const Text('Essa ação não poderar ser desfeita!'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Voltar',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        TextButton(
          onPressed: () {
            context.read<ProductManager>().delete(product);
            int count = 0;
            Navigator.popUntil(context, (route) {
              return count++ == 2;
            });

            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
          },
          child: Text(
            'Deletar Produto',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
