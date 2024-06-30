import 'dart:convert';
import 'dart:typed_data';

import 'docu_ng_platform_interface.dart';

class DocuNg {
  /// Function to scan document image. Shows a modal on screen and allows user to capture the image
  Future<Uint8List?> scanDocument() {
    return DocuNgPlatform.instance.scanDocument().then((base64image) {
      if (base64image != null) {
        return Uint8List.fromList(base64Decode(base64image));
      }
      return null;
    });
  }

  /// Function to adjust document corners. Shows a modal on screen and allows user to move the document corners.
  /// returns cropped image
  Future<Uint8List?> adjustDocumentCorners(Uint8List image) async {
    String base64image = base64Encode(image);
    return DocuNgPlatform.instance
        .adjustDocumentCorners(base64image)
        .then((result) {
      if (result != null) return Uint8List.fromList(base64Decode(result));
      return null;
    });
  }

  /// Function to adjust document contrast. Returns image as a [Uint8List] with adjusted contrast
  Future<Uint8List> adjustDocumentContrast(
      Uint8List image, double contrast) async {
    String base64image = base64Encode(image);

    return DocuNgPlatform.instance
        .adjustDocumentContrast(base64image, contrast)
        .then((result) {
      return Uint8List.fromList(base64Decode(result));
    });
  }
}
