import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/address_screenshot.dart';
import 'package:screenshot/screenshot.dart';

class ExportAddressDialog extends StatefulWidget {
  ExportAddressDialog(this.address, this.name);

  final name;
  final Address address;

  @override
  _ExportAddressDialogState createState() => _ExportAddressDialogState();
}

class _ExportAddressDialogState extends State<ExportAddressDialog> {
  
  final ScreenshotController screenshotController = ScreenshotController();
  final AddressScreenShot addressScreenShot = AddressScreenShot();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Endereço de Entrega'),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: const EdgeInsets.all(8),

          color: Colors.white,
          child: Text(
            'Nome: ${widget.name}\n'
            'Rua: ${widget.address.street}, numero: ${widget.address.number}\n' 
            'Complemento: ${widget.address.complement}\n'
            'Bairro: ${widget.address.district}\n'
            'Cidade: ${widget.address.city}, UF: ${widget.address.state}\n'
            'CEP: ${widget.address.zipCode}',
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            addressScreenShot.savePrint(screenshotController);
            Navigator.of(context).pop();
          },
          child: const Text(
            'Exportar',
          ),
        ),
      ],
    );
  }
}
