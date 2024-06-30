import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:docu_ng/docu_ng.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Scanner Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? _scannedImage;
  Uint8List? _cropImage;
  Uint8List? _displayImage;

  Future<void> _scanDocument() async {
    try {
      final image = await DocuNg().scanDocument();
      setState(() {
        _scannedImage = image;
        _cropImage = image;
        _displayImage = image;
      });
    } catch (e) {
      print("Failed to scan document: $e");
    }
  }

  Future<void> _adjustDocumentCorners() async {
    if (_scannedImage != null) {
      try {
        final adjustedImage =
            await DocuNg().adjustDocumentCorners(_scannedImage!);
        setState(() {
          _displayImage = adjustedImage;
          _cropImage = adjustedImage;
        });
      } catch (e) {
        print("Failed to adjust document corners: $e");
      }
    }
  }

  Future<void> _adjustContrast() async {
    if (_cropImage != null) {
      double? contrast = await showDialog<double?>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (context) {
            double contrast = 100;
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text('Set contrast'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("Contrast: ${contrast.round()}%"),
                      Slider(
                        value: contrast,
                        max: 200,
                        label: contrast.round().toString(),
                        onChanged: (double value) {
                          print(value);
                          setState(() {
                            contrast = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Set contrast'),
                    onPressed: () async {
                      Navigator.of(context).pop(contrast);
                    },
                  ),
                ],
              );
            });
          });

      if (contrast != null) {
        try {
          final adjustedImage =
              await DocuNg().adjustDocumentContrast(_scannedImage!, contrast);
          setState(() {
            _displayImage = adjustedImage;
          });
        } catch (e) {
          print("Failed to adjust document contrast: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Scanner Example'),
      ),
      body: Center(
        child: _displayImage == null
            ? Text('No image scanned.')
            : Image.memory(_displayImage!),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _scanDocument,
            tooltip: 'Scan Document',
            child: Icon(Icons.camera_alt),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _adjustDocumentCorners,
            tooltip: 'Adjust Corners',
            child: Icon(Icons.crop),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _adjustContrast,
            tooltip: 'Adjust Contrast',
            child: Icon(Icons.contrast),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              if (_displayImage != null) {
                DocuNg().copyImageToClipboard(_displayImage!);
              }
            },
            tooltip: 'Copy (Share)',
            child: Icon(Icons.copy),
          ),
        ],
      ),
    );
  }
}
