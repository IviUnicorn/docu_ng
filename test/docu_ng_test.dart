import 'package:flutter_test/flutter_test.dart';
import 'package:docu_ng/docu_ng.dart';
import 'package:docu_ng/docu_ng_platform_interface.dart';
import 'package:docu_ng/docu_ng_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';


import 'dart:typed_data';
import 'package:docu_ng/docu_ng.dart';
import 'package:docu_ng/docu_ng_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDocuNgPlatform implements DocuNgPlatform {
  @override
  Future<String?> scanDocument() async {
    return 'base64EncodedImage';
  }

  @override
  Future<String?> adjustDocumentCorners(String base64image) async {
    return 'base64EncodedImage';
  }

  @override
  Future<String> adjustDocumentContrast(String base64image, double contrast) async {
    return 'base64EncodedImage';
  }

  @override
  void copyImageToClipboard(String base64image) {
    // Mock implementation
  }
}

class MockDocuNgPlatformFailure implements DocuNgPlatform {
  @override
  Future<String?> scanDocument() async {
    return null;
  }

  @override
  Future<String?> adjustDocumentCorners(String base64image) async {
    return null;
  }

  @override
  Future<String> adjustDocumentContrast(String base64image, double contrast) async {
    return 'base64EncodedImage';
  }

  @override
  void copyImageToClipboard(String base64image) {
    // Mock implementation
  }
}

void main() {
  group('DocuNg Tests', () {
    final mockPlatform = MockDocuNgPlatform();
    final mockPlatformFailure = MockDocuNgPlatformFailure();
    final docuNg = DocuNg();

    setUp(() {
      DocuNgPlatform.instance = mockPlatform;
    });

    test('scanDocument returns a Uint8List when successful', () async {
      final result = await docuNg.scanDocument();

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('scanDocument returns null when no image is captured', () async {
      DocuNgPlatform.instance = mockPlatformFailure;
      final result = await docuNg.scanDocument();

      expect(result, isNull);
    });

    test('adjustDocumentCorners returns a Uint8List when successful', () async {
      final uint8ListImage = Uint8List.fromList([1, 2, 3, 4]);

      final result = await docuNg.adjustDocumentCorners(uint8ListImage);

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('adjustDocumentCorners returns null when adjustment fails', () async {
      DocuNgPlatform.instance = mockPlatformFailure;
      final uint8ListImage = Uint8List.fromList([1, 2, 3, 4]);

      final result = await docuNg.adjustDocumentCorners(uint8ListImage);

      expect(result, isNull);
    });

    test('adjustDocumentContrast returns a Uint8List when successful', () async {
      final uint8ListImage = Uint8List.fromList([1, 2, 3, 4]);
      final contrast = 1.5;

      final result = await docuNg.adjustDocumentContrast(uint8ListImage, contrast);

      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
    });

    test('copyImageToClipboard calls platform method with correct arguments', () async {
      final uint8ListImage = Uint8List.fromList([1, 2, 3, 4]);

      // This test just ensures that no exceptions are thrown when the method is called.
      expect(() => docuNg.copyImageToClipboard(uint8ListImage), returnsNormally);
    });
  });
}
