import 'package:flutter/material.dart';
import 'package:loja_virtual/models/admin_orders_Manager.dart';
import 'package:loja_virtual/models/admin_users_manager.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/checkout_manager.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/orders_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/stores_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/address/address_screen.dart';
import 'package:loja_virtual/screens/base/base_screen.dart';
import 'package:loja_virtual/screens/cart/cart_screen.dart';
import 'package:loja_virtual/screens/checkout/checkout_screen.dart';
import 'package:loja_virtual/screens/confimation/confirmation_screen.dart';
import 'package:loja_virtual/screens/edit_product/edit_product_screen.dart';
import 'package:loja_virtual/screens/login/login_screen.dart';
import 'package:loja_virtual/screens/product/product_screen.dart';
import 'package:loja_virtual/screens/select_product/select_product_screen.dart';
import 'package:loja_virtual/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CheckoutManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => StoresManager(),
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
              ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManger, adminUsersManage) =>
              adminUsersManage..updateUser(userManger),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManger, adminOrdersManage) => adminOrdersManage
            ..updateAdmin(adminEnabled: userManger.adminEnabled),
        ),
      ],
      child: MaterialApp(
        title: 'QI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 0, 77, 64),
          // secondaryHeaderColor: const Color.fromARGB(255, 102, 187, 106),
          scaffoldBackgroundColor: const Color.fromARGB(255, 225, 225, 225),
          // scaffoldBackgroundColor: const Color.fromARGB(255, 0, 77, 64),
          // scaffoldBackgroundColor: Colors.blue,
          appBarTheme: const AppBarTheme(elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/signup':
              return MaterialPageRoute(
                builder: (_) => SignUpScreen(),
              );

            case '/login':
              return MaterialPageRoute(  
                builder: (_) => LoginScreen(),
              );

            case '/cart':
              return MaterialPageRoute(
                builder: (_) => CartScreen(),
                settings: settings,
              );

            case '/address':
              return MaterialPageRoute(
                builder: (_) => AddressScreen(),
              );

            case '/checkout':
              return MaterialPageRoute(
                builder: (_) => CheckoutScreen(),
              );

            case '/select_product':
              return MaterialPageRoute(
                builder: (_) => SelectProductScreen(),
              );

            case '/product':
              return MaterialPageRoute(
                builder: (_) => ProductScreen(settings.arguments as Product),
              );

            case '/edit_product':
              return MaterialPageRoute(
                builder: (_) =>
                    EditProductScreen(settings.arguments as Product),
              );

            case '/confirmation':
              return MaterialPageRoute(
                builder: (_) => ConfirmationScreen(settings.arguments as Order),
              );

            case '/':
            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}
