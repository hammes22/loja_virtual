import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:loja_virtual/helpers/validators.dart';


class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Color prymaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: prymaryColor,
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/signup');
            },
            child: const Text(
              'CRIAR CONTA',
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  padding: EdgeInsets.all(16),
                  // comando faz o ListView ocupar a menor altura possivel
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (email) {
                        if (!emailValid(email)) {
                          return 'E-mail inválido';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: passController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      autocorrect: false,
                      obscureText: true,
                      validator: (pass) {
                        if (pass.isEmpty || pass.length < 6) {
                          return 'Senha inválida ';
                        } else {
                          return null;
                        }
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text('Esqueci minha senha'),
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, primary: prymaryColor),
                        // padding: EdgeInsets.zero, primary: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (formKey.currentState.validate()) {
                                userManager.signIn(
                                  user: User(
                                    email: emailController.text,
                                    password: passController.text,
                                  ),
                                  onFail: (e) {
                                    scaffoldKey.currentState
                                        // ignore: deprecated_member_use
                                        .showSnackBar(SnackBar(
                                      content: Text('Falha ao entrar: $e'),
                                      backgroundColor: Colors.red,
                                    ));
                                  },
                                  onSuccess: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              }
                            },
                      child: userManager.loading
                          ? CircularProgressIndicator()
                          : const Text(
                              'Entrar',
                            ),
                      style: ElevatedButton.styleFrom(
                        primary: prymaryColor, // background
                        onPrimary: Colors.white, // foreground
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                   
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
