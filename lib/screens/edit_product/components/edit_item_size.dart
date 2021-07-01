import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class EditItemSize extends StatelessWidget {
  const EditItemSize(
      {key, this.size, this.onRemove, this.onMoveUp, this.onMoveDown})
      : super(key: key);
  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 6),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 30,
              child: TextFormField(
                initialValue: size.name,
                decoration: const InputDecoration(
                  labelText: 'Titulo',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (name) {
                  if (name.isEmpty) return 'Inválido';
                  return null;
                },
                onChanged: (name) => size.name = name.toUpperCase(),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Expanded(
              flex: 30,
              child: TextFormField(
                initialValue: size.stock?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Estoque',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (stock) {
                  if (int.tryParse(stock) == null) return 'Inválido';
                  return null;
                },
                onChanged: (stock) => size.stock = int.tryParse(stock),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 30,
              child: TextFormField(
                initialValue: size.price?.toStringAsFixed(2),
                decoration: const InputDecoration(
                  labelText: 'Preço',
                  prefixText: 'R\$',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),

                validator: (price) {
                  if (price.isEmpty) return 'Inválido';
                  return null;
                },
                inputFormatters: [CurrencyTextInputFormatter(symbol: '')],

                // validator: (price) {
                //   if (num.tryParse(price) == null) return 'Inválido';
                //   return null;
                // },
                onChanged: (price) => size.price = num.tryParse(price),
              ),
            ),
            CustomIconButton(
              iconData: Icons.remove,
              color: Colors.red,
              onTap: onRemove,
            ),
            CustomIconButton(
              iconData: Icons.arrow_drop_up,
              color: Colors.black,
              onTap: onMoveUp,
            ),
            CustomIconButton(
              iconData: Icons.arrow_drop_down,
              color: Colors.black,
              onTap: onMoveDown,
            ),
          ],
        ));
  }
}