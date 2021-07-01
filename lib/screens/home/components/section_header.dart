import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:provider/provider.dart';

class SectionHeader extends StatelessWidget {
  SectionHeader();

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final section = context.watch<Section>();
    if (homeManager.editing) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: section.name,
                    decoration: const InputDecoration(
                      labelText: 'Titulo',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                    onChanged: (text) => section.name = text,
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.remove,
                  color: Colors.red,
                  onTap: () {
                    homeManager.removeSection(section);
                  },
                ),
                CustomIconButton(
                  iconData: Icons.arrow_drop_up,
                  color: Colors.black,
                  onTap: homeManager.UpSection(section),
                ),
                CustomIconButton(
                  iconData: Icons.arrow_drop_down,
                  color: Colors.black,
                  onTap: homeManager.DownSection(section),
                ),
              ],
            ),
          ),
          if (section.error != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(section.error, style: TextStyle(color: Colors.red)),
            )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          section.name ?? "teste",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      );
    }
  }
}
