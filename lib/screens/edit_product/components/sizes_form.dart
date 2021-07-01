import 'package:flutter/material.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/edit_product/components/edit_item_size.dart';

class SizesForms extends StatelessWidget {
  const SizesForms({this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes,
      validator: (sizes) {
        if (sizes.isEmpty) return 'Insira um campo';
        return null;
      },
      builder: (state) {
        return Column(
          children: [
            Column(
              children: state.value.map((size) {
                return EditItemSize(
                  key: ObjectKey(size),
                  size: size,
                  onRemove: () {
                    state.value.remove(size);
                    state.didChange(state.value);
                  },
                  onMoveUp: size != state.value.first
                      ? () {
                          final index = state.value.indexOf(size);
                          state.value.remove(size);
                          state.value.insert(index - 1, size);
                          state.didChange(state.value);
                        }
                      : null,
                  onMoveDown: size != state.value.last
                      ? () {
                          final index = state.value.indexOf(size);
                          state.value.remove(size);
                          state.value.insert(index + 1, size);
                          state.didChange(state.value);
                        }
                      : null,
                );
              }).toList(),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(state.errorText,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    )),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                state.value.add(ItemSize());
                state.didChange(state.value);
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor, // background
                onPrimary: Colors.white, // foreground
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add),
                  const SizedBox(width: 6),
                  const Text('Adicionar Campo'),
                  const SizedBox(width: 6),
                  Icon(Icons.add),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
