import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class AddressInputField extends StatelessWidget {
  const AddressInputField(this.address);

  final Address address;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();

    String emptyValidator(String text) =>
        text.isEmpty ? 'Campo obrigatório' : null;
    if (address.zipCode != null && cartManager.deliveryPrice == null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 8),
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.street,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Rua/Avenida',
              hintText: 'Av. Brasil',
              border: OutlineInputBorder(),
            ),
            validator: emptyValidator,
            onSaved: (t) => address.street = t,
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Número',
                    border: OutlineInputBorder(),
                    // hintText: '123',
                  ),
                  inputFormatters: [
                    // ignore: deprecated_member_use
                    // WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  // keyboardType: TextInputType.number,
                  validator: emptyValidator,
                  onSaved: (t) => address.number = t,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.complement,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (t) => address.complement = t,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.district,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Bairro',
              hintText: 'Guanabara',
              border: OutlineInputBorder(),
            ),
            validator: emptyValidator,
            onSaved: (t) => address.district = t,
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: TextFormField(
                  enabled: false,
                  initialValue: address.city,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Cidade',
                    hintText: 'Campinas',
                    border: OutlineInputBorder(),
                  ),
                  validator: emptyValidator,
                  onSaved: (t) => address.city = t,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  autocorrect: false,
                  enabled: false,
                  textCapitalization: TextCapitalization.characters,
                  initialValue: address.state,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'UF',
                    hintText: 'SP',
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 2,
                  validator: (e) {
                    if (e.isEmpty) {
                      return 'Campo obrigatório';
                    } else if (e.length != 2) {
                      return 'Inválido';
                    }
                    return null;
                  },
                  onSaved: (t) => address.state = t,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            child: cartManager.loading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                    backgroundColor: Colors.transparent,
                  )
                : const Text('Calcular Frete'),
            onPressed: !cartManager.loading
                ? () async {
                    if (Form.of(context).validate()) {
                      Form.of(context).save();
                      try {
                        await context.read<CartManager>().setAddress(address);
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
    else if (address.zipCode != null)
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
            '${address.street},  Número ${address.number}\nBairro ${address.district}\n'
            '${address.city} - ${address.state}'),
      );
    else
      return Container();
  }
}
