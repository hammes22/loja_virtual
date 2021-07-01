import 'package:flutter/material.dart';
import 'package:loja_virtual/models/order.dart';
import 'cancel_order_dialog.dart';
import 'export_address_dialog.dart';
import 'order_product_tile.dart';

class OrderTile extends StatelessWidget {
  const OrderTile(this.order, {this.showControls = false});

  final Order order;
  final bool showControls;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (showControls)
              Container(
                child: Text(
                  'Nome: ${order.name}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      order.formattedId,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'R\$ ${order.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  order.statusText,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: order.status == Status.canceled
                          ? Colors.red
                          : primaryColor,
                      fontSize: 14),
                )
              ],
            ),
          ],
        ),
        children: <Widget>[
          Column(
            children: order.items.map((e) {
              return OrderProductTile(e);
            }).toList(),
          ),
          if (showControls && order.status != Status.canceled)
            //  if (showControls && order.status != Status.canceled && order.status != Status.delivered)
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => CancelOrderDialog(order));
                    },
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: order.back,
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(Icons.arrow_back),
                        Text('Recuar')
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: order.advance,
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(Icons.arrow_forward),
                        Text('Avançar')
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => ExportAddressDialog(order.address, order.name));
                    },
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: primaryColor,
                        ),
                        Text(
                          'Endereço',
                          style: TextStyle(color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
