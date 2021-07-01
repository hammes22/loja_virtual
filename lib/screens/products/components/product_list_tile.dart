import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:loja_virtual/models/product.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {
    // if (product.hasStock)
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/product', arguments: product);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: FadeInImage.assetNetwork(
                  placeholder: cupertinoActivityIndicatorSmall,
                  image: product.images.first,
                ),
                //child: Image.network(product.images.first),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (product.basePrice == 0)
                      Text(
                        'Produto Indisponivel',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).primaryColor),
                      )
                    else
                      Text(
                        'R\$ ${product.basePrice.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).primaryColor),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // else
    //   return Card();
  }
}
