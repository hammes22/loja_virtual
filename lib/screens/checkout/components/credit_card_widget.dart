import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/screens/checkout/components/card_back.dart';
import 'package:loja_virtual/screens/checkout/components/card_front.dart';

class CreditCardWidget extends StatefulWidget {
  const CreditCardWidget(this.creditCard);
  final CreditCard creditCard;
  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FlipCardState> cardkey = GlobalKey();
    final FocusNode numberFocus = FocusNode();
    final FocusNode dateFocus = FocusNode();
    final FocusNode nameFocus = FocusNode();
    final FocusNode cvvFocus = FocusNode();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FlipCard(
            key: cardkey,
            direction: FlipDirection.VERTICAL,
            speed: 700,
            flipOnTouch: false,
            front: CardFront(
              creditCard: widget.creditCard,
              numberFocus: numberFocus,
              dateFocus: dateFocus,
              nameFocus: nameFocus,
              finished: () {
                cardkey.currentState.toggleCard();
                cvvFocus.requestFocus();
              },
            ),
            back: CardBack(
              creditCard: widget.creditCard,
              cvvFocus: cvvFocus,
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: TextButton(
              onPressed: () {
                cardkey.currentState.toggleCard();
              },
              child: Text(
                'Virar cartão',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
