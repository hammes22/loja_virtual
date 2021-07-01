import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/checkout_manager.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/screens/checkout/components/cpf_field.dart';
import 'package:loja_virtual/screens/checkout/components/credit_card_widget.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final CreditCard creditCard = CreditCard();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
          key: scaffoldkey,
          appBar: AppBar(
            title: const Text('Pagamento'),
            centerTitle: true,
          ),
          body: Consumer<CheckoutManager>(
            builder: (_, checkoutManager, __) {
              if (checkoutManager.loading) {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Processando seu pagamento...',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Form(
                key: formkey,
                child: ListView(
                  children: <Widget>[
                    CreditCardWidget(creditCard),
                    CpfField(),
                    PriceCard(
                      buttonText: 'Finalizar Pedido',
                      onPressed: () {
                        if (formkey.currentState.validate()) {
                          formkey.currentState.save();
                          print('pedido enviado');
                          print(creditCard);
                          checkoutManager.checkout(
                              creditCard: creditCard,
                              onStockFail: (e) {
                                // Navigator.of(context).popUntil(
                                //         (route) => route.settings.name == '/cart');
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text('Estoque insuficiente'),
                                    titleTextStyle: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        // fontWeight: FontWeight.w600,
                                        fontSize: 22),
                                    content: Text(
                                        'O seu carrinho contém produtos com estoque insuficiente \n'
                                        'Verifique o carrinho'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).popUntil(
                                              (route) =>
                                                  route.settings.name ==
                                                  '/cart');
                                        },
                                        child: Text(
                                          'OK',
                                          style: TextStyle(fontSize: 22),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onPayFail: (e) {
                                // ignore: deprecated_member_use
                                scaffoldkey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('$e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                              onSuccess: (order) {
                                Navigator.of(context).popUntil(
                                    (route) => route.settings.name == '/');
                                Navigator.of(context).pushNamed('/confirmation',
                                    arguments: order);
                              });
                        }
                      },
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
