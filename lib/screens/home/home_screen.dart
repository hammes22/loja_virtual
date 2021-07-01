import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/home/components/section_list.dart';
import 'package:loja_virtual/screens/home/components/section_staggered.dart';
import 'package:loja_virtual/screens/home/components/section_staggered_colunm.dart';
import 'package:provider/provider.dart';

import 'components/add_section_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            snap: true,
            floating: true,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('QI'),
              centerTitle: true,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined),
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed('/cart'),
              ),
              Consumer2<UserManager, HomeManager>(
                builder: (_, userManager, homeManager, __) {
                  if (userManager.adminEnabled && !homeManager.loading) {
                    if (homeManager.editing) {
                      return PopupMenuButton(
                        onSelected: (e) {
                          if (e == 'Salvar') {
                            homeManager.saveEditing();
                          } else {
                            homeManager.discardEditing();
                          }
                        },
                        itemBuilder: (_) {
                          return ['Salvar', 'Descartar'].map((e) {
                            return PopupMenuItem(
                              value: e,
                              child: Text(e),
                            );
                          }).toList();
                        },
                      );
                    } else {
                      return IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: homeManager.enterEditing,
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
          Consumer<HomeManager>(builder: (_, homeManager, __) {
            if (homeManager.loading) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 100),
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              );
            }
            final List<Widget> children =
                homeManager.sections.map<Widget>((section) {
              switch (section.type) {
                case 'List':
                  return SectionList(section);
                case 'Staggered':
                  return SectionStaggered(section);
                case 'Colunm':
                  return SectionStaggeredColunm(section);
                default:
                  return Container();
              }
            }).toList();
            if (homeManager.editing)
              children.add(AddSectionWidget(homeManager));
            return SliverList(
              delegate: SliverChildListDelegate(children),
            );
          }),
        ],
      ),
    );
  }
}
