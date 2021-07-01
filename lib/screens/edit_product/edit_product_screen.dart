import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/screens/edit_product/components/delete_item_size.dart';
import 'package:loja_virtual/screens/edit_product/components/images_form.dart';
import 'package:loja_virtual/screens/edit_product/components/sizes_form.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Product p)
      : editing = p != null,
        product = p != null ? p.clone() : Product();
  final Product product;
  final bool editing;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(editing ? 'Editar Produto' : 'Criar Produto'),
          centerTitle: true,
          actions: <Widget>[
            if (editing)
              IconButton(
                onPressed: () {
                  showDialog(
                          context: context,
                          builder: (_) => DeleteItemSize(product));
                  // context.read<ProductManager>().delete(product);
                },
                icon: Icon(Icons.delete),
              ),
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              ImagesForm(product),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                        labelText: 'Titulo',
                        border: OutlineInputBorder(),
                      ),
                      validator: (name) {
                        if (name.length < 6) return 'Titulo muito curto';
                        return null;
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'A partir de',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ),
                    Text(
                      'R\$...',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: TextFormField(
                        initialValue: product.description,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                        validator: (name) {
                          if (name.length < 6) return 'Descrição muito curta';
                          return null;
                        },
                        onSaved: (desc) => product.description = desc,
                      ),
                    ),
                    SizesForms(product: product),
                    const SizedBox(height: 10),
                    Consumer<Product>(builder: (_, product, __) {
                      return SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: !product.loading
                              ? () async {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                    await product.save();

                                    context
                                        .read<ProductManager>()
                                        .update(product);

                                    Navigator.of(context).pop();
                                  }
                                }
                              : null,
                          child: product.loading
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text('Salvar'),
                          style: ElevatedButton.styleFrom(
                            primary:
                                Theme.of(context).primaryColor, // background
                            onPrimary: Colors.white, // foreground
                            textStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
