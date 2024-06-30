import 'dart:convert';
import 'dart:typed_data';

import 'docu_ng_platform_interface.dart';

class DocuNg {
  Future<Uint8List?> scanDocument() {
    return DocuNgPlatform.instance.scanDocument().then((base64image) {
      if (base64image != null) {
        return Uint8List.fromList(base64Decode(base64image));
      }
      return null;
    });
  }

  Future<Uint8List?> adjustDocumentCorners(Uint8List image) async {
    String base64image = base64Encode(image);
    return DocuNgPlatform.instance
        .adjustDocumentCorners(base64image)
        .then((result) {
      if (result != null) return Uint8List.fromList(base64Decode(result));
      return null;
    });
  }

  Uint8List adjustDocumentContrast(Uint8List image, double contrast) {
    String base64image = base64Encode(image);
    return Uint8List.fromList(base64Decode(
        DocuNgPlatform.instance.adjustDocumentContrast(base64image, contrast)));
  }
}
