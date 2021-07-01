import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({this.onImageSelected});

  final Function(File) onImageSelected;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Future<void> editImage(String path) async {
      final File croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Editar imagem',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
        ),
      );
      if (croppedFile != null) {
        onImageSelected(croppedFile);
      }
    }

    final Color primary = Theme.of(context).primaryColor;
    if (Platform.isAndroid)
      return BottomSheet(
        onClosing: () {},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: primary,
              ),
              title: Text('Câmera',
                  style: TextStyle(color: primary, fontSize: 20)),
              onTap: () async {
                final file = await picker.getImage(source: ImageSource.camera);
                editImage(file.path);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.add_photo_alternate,
                color: primary,
              ),
              title: Text('Galeria',
                  style: TextStyle(color: primary, fontSize: 20)),
              onTap: () async {
                final file = await picker.getImage(source: ImageSource.gallery);
                editImage(file.path);
              },
            ),
          ],
        ),
      );
    else
      return CupertinoActionSheet(
        title: Text('Selecionar foto para o item'),
        message: Text('Escolha a origem da foto'),
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: Navigator.of(context).pop,
        ),
        actions: [
          CupertinoActionSheetAction(
              onPressed: () async {
                final file = await picker.getImage(source: ImageSource.camera);
                editImage(file.path);
              },
              child: const Text('Câmera')),
          CupertinoActionSheetAction(
              onPressed: () async {
                final file = await picker.getImage(source: ImageSource.gallery);
                editImage(file.path);
              },
              child: const Text('Galeria'))
        ],
      );
  }
}
