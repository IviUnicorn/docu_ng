# DocuNG

DocuNG is a Flutter package that provides functionalities to scan, adjust, and manage document images. The package supports capturing document images, adjusting their corners, enhancing contrast, and copying or sharing the images across different platforms. 

## Features

- **Scan Document:** Capture document images using a modal interface.
- **Adjust Document Corners:** Manually adjust the corners of the captured document for better cropping.
- **Adjust Document Contrast:** Enhance the contrast of the document images.
- **Copy or Share Images:** Copy images to the clipboard or share them across different platforms.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  docu_ng: ^1.0.0
```

Then run:

```sh
flutter pub get
```

## Usage

### Importing the Package

```dart
import 'package:docu_ng/docu_ng.dart';
```

### Scanning a Document

The `scanDocument` function displays a modal interface allowing the user to capture a document image.

```dart
Uint8List? documentImage = await DocuNG().scanDocument();
if (documentImage != null) {
  // Use the captured document image
}
```

### Adjusting Document Corners

The `adjustDocumentCorners` function displays a modal interface for adjusting the corners of the captured document. It returns the cropped image.

```dart
Uint8List? adjustedImage = await DocuNG().adjustDocumentCorners(documentImage);
if (adjustedImage != null) {
  // Use the adjusted document image
}
```

### Adjusting Document Contrast

The `adjustDocumentContrast` function adjusts the contrast of the document image and returns the modified image.

```dart
double contrast = 1.5; // Adjust contrast value as needed
Uint8List contrastAdjustedImage = await DocuNG().adjustDocumentContrast(documentImage, contrast);
// Use the contrast-adjusted document image
```

### Copying Image to Clipboard

The `copyImageToClipboard` function copies the document image to the clipboard (on web or Windows) or shares it (on Android or iOS).

```dart
DocuNG().copyImageToClipboard(documentImage);
```

## API Reference

### `Future<Uint8List?> scanDocument()`

Displays a modal interface for capturing a document image.

**Returns:** 
- `Uint8List?`: The captured document image or `null` if no image is captured.

### `Future<Uint8List?> adjustDocumentCorners(Uint8List image)`

Displays a modal interface for adjusting the corners of the captured document image.

**Parameters:** 
- `Uint8List image`: The captured document image.

**Returns:** 
- `Uint8List?`: The adjusted document image or `null` if the adjustment is not completed.

### `Future<Uint8List> adjustDocumentContrast(Uint8List image, double contrast)`

Adjusts the contrast of the document image.

**Parameters:** 
- `Uint8List image`: The document image.
- `double contrast`: The contrast value to be applied.

**Returns:** 
- `Uint8List`: The contrast-adjusted document image.

### `void copyImageToClipboard(Uint8List image)`

Copies the document image to the clipboard (on web or Windows) or shares it (on Android or iOS).

**Parameters:** 
- `Uint8List image`: The document image to be copied or shared.

## Example

```dart
import 'package:flutter/material.dart';
import 'package:docu_ng/docu_ng.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Uint8List? _documentImage;

  Future<void> _scanDocument() async {
    Uint8List? documentImage = await DocuNG().scanDocument();
    setState(() {
      _documentImage = documentImage;
    });
  }

  Future<void> _adjustCorners() async {
    if (_documentImage != null) {
      Uint8List? adjustedImage = await DocuNG().adjustDocumentCorners(_documentImage!);
      setState(() {
        _documentImage = adjustedImage;
      });
    }
  }

  Future<void> _adjustContrast() async {
    if (_documentImage != null) {
      double contrast = 1.5;
      Uint8List contrastAdjustedImage = await DocuNG().adjustDocumentContrast(_documentImage!, contrast);
      setState(() {
        _documentImage = contrastAdjustedImage;
      });
    }
  }

  void _copyToClipboard() {
    if (_documentImage != null) {
      DocuNG().copyImageToClipboard(_documentImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DocuNG Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_documentImage != null)
              Image.memory(_documentImage!),
            ElevatedButton(
              onPressed: _scanDocument,
              child: Text('Scan Document'),
            ),
            ElevatedButton(
              onPressed: _adjustCorners,
              child: Text('Adjust Corners'),
            ),
            ElevatedButton(
              onPressed: _adjustContrast,
              child: Text('Adjust Contrast'),
            ),
            ElevatedButton(
              onPressed: _copyToClipboard,
              child: Text('Copy to Clipboard'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or new features.

---

With DocuNG, managing document images in your Flutter applications becomes seamless and efficient. Whether you need to capture, adjust, enhance, or share document images, DocuNG provides a straightforward and user-friendly solution.