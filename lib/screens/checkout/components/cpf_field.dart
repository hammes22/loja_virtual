import 'package:brasil_fields/formatter/cpf_input_formatter.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CpfField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();

    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: TextFormField(
          initialValue: userManager.user.cpf,
          decoration: InputDecoration(
            labelText: 'CPF',
            labelStyle: TextStyle(color: primaryColor),
            hoverColor: primaryColor,
            hintText: '000.000.000-00',
            isDense: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CpfInputFormatter(),
          ],
          validator: (cpf) {
            if (cpf.isEmpty)
              return 'Campo Obrigatório';
            else if (!CPFValidator.isValid(cpf)) return 'CPF Inválido';

            return null;
          },
          onSaved: userManager.user.setCpf,
        ),
      ),
    );
  }
}
