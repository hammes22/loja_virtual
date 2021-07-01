import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:loja_virtual/screens/edit_product/components/image_souce_sheet.dart';
import 'package:provider/provider.dart';

class AddTileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final section = context.watch<Section>();

    void onImageSelected(File file) {
      section.addItem(SectionItem(image: file));
      Navigator.of(context).pop();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () {
          if (Platform.isAndroid) {
            showModalBottomSheet(
              context: context,
              builder: (context) =>
                  ImageSourceSheet(onImageSelected: onImageSelected),
            );
          } else {
            showCupertinoModalPopup(
              context: context,
              builder: (context) =>
                  ImageSourceSheet(onImageSelected: onImageSelected),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[80],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          ),
          child: Icon(
            Icons.add,
            size: 50,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
