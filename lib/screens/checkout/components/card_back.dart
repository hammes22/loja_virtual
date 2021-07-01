import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';

class CardBack extends StatelessWidget {
  const CardBack({this.cvvFocus, this.creditCard});

  final FocusNode cvvFocus;
  final CreditCard creditCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      child: Container(
        color: const Color(0xFF1B4B52),
        height: 200,
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: 40,
              margin: EdgeInsets.symmetric(vertical: 16),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 70,
                  child: Container(
                    color: Colors.grey[500],
                    margin: EdgeInsets.only(left: 12),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: CardTextField(
                      initialValue: creditCard.securityCode,
                      hint: '123',
                      maxLength: 3,
                      textAlign: TextAlign.end,
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (cvv) {
                        if (cvv.length != 3) return 'Inválido';
                        return null;
                      },
                      onSubmitted: (_) {},
                      focusNode: cvvFocus,
                      onSaved: creditCard.setCVV,
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Container(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
