import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';

class CartProduct extends ChangeNotifier {
  CartProduct.fromProduct(this._product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    productId = document.data['pid'] as String;
    quantity = document.data['quantity'] as int;
    size = document.data['size'] as String;
    firestore.document('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPice = map['fixedPrice'] as num;

    firestore.document('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  final Firestore firestore = Firestore.instance;

  String id;
  String productId;
  int quantity;
  String size;

  num fixedPice;

  Product _product;
  Product get product => _product;
  set product(Product value) {
    _product = value;
    notifyListeners();
  }

  ItemSize get itemSize {
    if (product == null) {
      return null;
    } else {
      return product.findSize(size);
    }
  }

  bool get hasStok {
    if (product != null && product.deleted) return false;

    final size = itemSize;
    if (size == null) return false;
    return size.stock >= quantity;
  }

  num get unitPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
  }

  num get totalPrice {
    return unitPrice * quantity;
  }

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPice ?? unitPrice,
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }
}
