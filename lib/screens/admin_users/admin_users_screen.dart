import 'package:flutter/material.dart';
import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/admin_orders_Manager.dart';
import 'package:loja_virtual/models/admin_users_manager.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:provider/provider.dart';

class AdminUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUserManager, __) {
          return AlphabetListScrollView(
            itemBuilder: (_, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    adminUserManager.users[index].name,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor,
                        fontSize: 16),
                  ),
                  subtitle: Text(
                    adminUserManager.users[index].email,
                  ),
                  onTap: () {
                    context
                        .read<AdminOrdersManager>()
                        .setUserFilter(adminUserManager.users[index]);
                    context.read<PageManager>().setPage(5);
                  },
                  dense: true,
                  isThreeLine: true,
                ),
              );
            },
            highlightTextStyle: TextStyle(
              fontSize: 20,
            ),
            indexedHeight: (index) => 80,
            strList: adminUserManager.names,
            showPreview: true,
            keyboardUsage: true,
          );
        },
      ),
    );
  }
}
