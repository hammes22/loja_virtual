import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/services/cielo_payment.dart';
import 'credit_card.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager cartManager;
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final Firestore firestore = Firestore.instance;
  final CieloPayment cieloPayment = CieloPayment();

  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout({
    CreditCard creditCard,
    Function onStockFail,
    Function onSuccess,
    Function onPayFail,
  }) async {
    loading = true;

    final orderId = await _getorderId();

    String payId;
    try {
      payId = await cieloPayment.authorize(
        creditCard: creditCard,
        price: cartManager.totalPrice,
        orderId: orderId.toString(),
        user: cartManager.user,
      );
      debugPrint('success $payId');
    } catch (e) {
      onPayFail(e);
      loading = false;
      return;
    }

    try {
      await _decrementStock();
    } catch (e) {
      cieloPayment.cancel(payId);
      onStockFail(e);
      loading = false;
      return;
    }

    // capturar pagamento
    try {
      await cieloPayment.capture(payId);
      print('sucesso na captura');
    } catch (e) {
      onPayFail(e);
      loading = false;
      return;
    }

    final order = Order.fromCartManager(cartManager);
    order.orderId = orderId.toString();
    order.payId = payId;

    await order.save();

    cartManager.clear();

    onSuccess(order);
    loading = false;
  }

  Future<int> _getorderId() async {
    final ref = firestore.document('aux/ordercounter');
    try {
      final result = await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(ref);
        final orderId = doc.data['current'] as int;
        await transaction.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      });
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  Future<void> _decrementStock() {
    // 1. Ler todos os estoques
    // 2. Decrementar localmente os estoques
    // 3. Salvar os estoques no fireBase

    return firestore.runTransaction((transaction) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for (final cartProduct in cartManager.items) {
        Product product;

        if (productsToUpdate.any((p) => p.id == cartProduct.productId)) {
          product =
              productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
        } else {
          final doc = await transaction.get(
            firestore.document('products/${cartProduct.productId}'),
          );
          product = Product.fromDocument(doc);
        }

        cartProduct.product = product;

        final size = product.findSize(cartProduct.size);
        if (size.stock - cartProduct.quantity < 0) {
          // Falha
          productsWithoutStock.add(product);
        } else {
          size.stock -= cartProduct.quantity;
          productsToUpdate.add(product);
        }
      }

      if (productsWithoutStock.isNotEmpty) {
        return Future.error(
            '${productsWithoutStock.length} produtos sem estoque');
      }

      for (final product in productsToUpdate) {
        transaction.update(
          firestore.document('products/${product.id}'),
          {'sizes': product.exportSizeList()},
        );
      }
    });
  }
}
