import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:uuid/uuid.dart';


class AddressScreenShot {
  Uint8List _imageFile;

  Future<void> savePrint(screenshotController) async {
    _imageFile = null;
    screenshotController.capture().then((Uint8List image) async {
      _imageFile = image;
      final result = await ImageGallerySaver.saveImage(
          (_imageFile.buffer.asUint8List()),
          quality: 60,
          name: Uuid().v1());
      print("File Saved to Gallery");
      print(result);
    });
  }
}
