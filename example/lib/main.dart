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
  double _contrast = 100;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Scanner Example'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            _displayImage == null
                ? Text('No image scanned.')
                : Image.memory(_displayImage!),
            _displayImage == null
                ? SizedBox()
                : Slider(
                    value: _contrast,
                    max: 200,
                    label: _contrast.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _contrast = value;
                        _displayImage  = DocuNg().adjustDocumentContrast(_displayImage!, _contrast);
                      });
                    },
                  )
          ])),
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
        ],
      ),
    );
  }
}
