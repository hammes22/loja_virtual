import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final User user = User();

  @override
  Widget build(BuildContext context) {
    final Color prymaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  // ListView vai ocupara o menor espaço possivel shrinkWrap: true,
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nome Completo',
                        border: OutlineInputBorder(),
                      ),
                      enabled: !userManager.loading,
                      validator: (name) {
                        if (name.isEmpty) {
                          return 'Campo Obrigatório';
                        } else if (name.trim().split(' ').length <= 1) {
                          return 'Preencha seu Nome completo';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (name) => user.name = name,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                      ),
                      enabled: !userManager.loading,
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        if (email.isEmpty) {
                          return 'Campo Obrigatório';
                        } else if (!emailValid(email)) {
                          return 'E-mail invalido';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (email) => user.email = email,
                    ),
                    //TODO: Criar um validador strong senha
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      enabled: !userManager.loading,
                      obscureText: true,
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return 'Campo Obrigatório';
                        } else if (pass.length < 6) {
                          return 'Senha muito curta';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (pass) => user.password = pass,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Repita a Senha',
                        border: OutlineInputBorder(),
                      ),
                      enabled: !userManager.loading,
                      obscureText: true,
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return 'Campo Obrigatório';
                        } else if (pass.length < 6) {
                          return 'Senha muito curta';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (pass) => user.confirmPassword = pass,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: userManager.loading
                            ? null
                            : () {
                                if (formKey.currentState.validate()) {
                                  //o .save vai chamar o metodo onSaved de cada um dos forms desta pagina
                                  formKey.currentState.save();

                                  if (user.password != user.confirmPassword) {
                                    scaffoldKey.currentState
                                        // ignore: deprecated_member_use
                                        .showSnackBar(SnackBar(
                                      content:
                                          const Text('Senhas não coincidem!'),
                                      backgroundColor: Colors.red,
                                    ));
                                    return;
                                  }
                                  userManager.signUp(
                                      user: user,
                                      onSuccess: () {
                                        //criar uma mensagem cadastro realizado com sucesso
                                        Navigator.of(context).pop();
                                      },
                                      onFail: (e) {
                                        scaffoldKey.currentState
                                            // ignore: deprecated_member_use
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text('Falha ao cadastrar: $e'),
                                          backgroundColor: Colors.red,
                                        ));
                                      });
                                }
                              },
                        child: userManager.loading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(prymaryColor),
                              )
                            : Text('Criar Conta'),
                        style: ElevatedButton.styleFrom(
                          primary: prymaryColor, // background
                          onPrimary: Colors.white, // foreground
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
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
