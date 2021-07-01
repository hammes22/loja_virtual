import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {
  const CepInputField(this.address);

  final Address address;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartmanager = context.watch<CartManager>();
    final primaryColor = Theme.of(context).primaryColor;

    String emptyValidator(String text) {
      if (text.isEmpty)
        return 'Campo obrigatório';
      else if (text.length != 10) return 'CEP Inválido';
      return null;
    }

    if (widget.address.zipCode == null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartmanager.loading,
            controller: cepController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'CEP',
                hintText: '12.345-678'),
            inputFormatters: [
              // ignore: deprecated_member_use
              WhitelistingTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            validator: emptyValidator,
          ),

          // if (cartmanager.loading) LinearProgressIndicator(),
          ElevatedButton(
            child: cartmanager.loading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                    backgroundColor: Colors.transparent,
                  )
                : const Text('Buscar CEP'),
            onPressed: !cartmanager.loading
                ? () async {
                    if (Form.of(context).validate()) {
                      try {
                        await context
                            .read<CartManager>()
                            .getAddress(cepController.text);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$e',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              onPrimary: Colors.white,
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
        ],
      );
    else
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: primaryColor,
              size: 20,
              onTap: () {
                context.read<CartManager>().removeAddress();
              },
            )
          ],
        ),
      );
  }
}
