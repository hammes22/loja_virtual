import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/common/orders/order_tile.dart';
import 'package:loja_virtual/models/admin_orders_Manager.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AdminOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final PanelController panelController = PanelController();

    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text('Todos os Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, adminOrdersManager, __) {
          final filteredOrders = adminOrdersManager.filteredOrders;

          return SlidingUpPanel(
            controller: panelController,
            body: Container(
              margin: EdgeInsets.only(bottom: 50),
              child: Column(
                children: <Widget>[
                  if (adminOrdersManager.userFilter != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Pedidos de ${adminOrdersManager.userFilter.name}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: primaryColor),
                            ),
                          ),
                          CustomIconButton(
                            iconData: Icons.close,
                            color: primaryColor,
                            onTap: () {
                              adminOrdersManager.setUserFilter(null);
                            },
                          )
                        ],
                      ),
                    ),
                  if (filteredOrders.isEmpty)
                    Expanded(
                      child: EmptyCard(
                        title: 'Nenhuma venda realizada!',
                        iconData: Icons.border_clear,
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                          itemCount: filteredOrders.length,
                          itemBuilder: (_, index) {
                            return OrderTile(
                              filteredOrders[index],
                              showControls: true,
                            );
                          }),
                    ),
                ],
              ),
            ),
            minHeight: 40,
            maxHeight: 240,
            panel: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (panelController.isPanelClosed) {
                      panelController.open();
                    } else {
                      panelController.close();
                    }
                  },
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      'Filtros',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values.map((s) {
                      return CheckboxListTile(
                        title: Text(
                          Order.getStatusText(s),
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        dense: true,
                        activeColor: primaryColor,
                        value: adminOrdersManager.statusFilter.contains(s),
                        onChanged: (v) {
                          adminOrdersManager.setStatusFilter(
                            status: s,
                            enalbed: v,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
