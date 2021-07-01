import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/section.dart';

class AddSectionWidget extends StatelessWidget {
  const AddSectionWidget(this.homeManager);

  final HomeManager homeManager;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    homeManager.addSection(Section(type: 'List'));
                  },
                  child: Text(
                    'Adicionar Lista',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              VerticalDivider(color: Theme.of(context).primaryColor),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    homeManager.addSection(Section(type: 'Staggered'));
                  },
                  child: Text(
                    'Adicionar Grade',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    homeManager.addSection(Section(type: 'Colunm'));
                  },
                  child: Text(
                    'Adicionar Banner',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
