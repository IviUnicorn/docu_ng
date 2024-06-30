// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'docu_ng_platform_interface.dart';

/// A web implementation of the DocuNgPlatform of the DocuNg plugin.
class DocuNgWeb extends DocuNgPlatform {
  /// Constructs a DocuNgWeb
  DocuNgWeb();

  static void registerWith(Registrar registrar) {
    DocuNgPlatform.instance = DocuNgWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> scanDocument() async {
    final completer = Completer<String?>();

    // I tried to add some styling, but finished with this
    final html.DivElement modal = html.DivElement()
      ..style.position = 'fixed'
      ..style.left = '0'
      ..style.top = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.backgroundColor = 'rgba(0, 0, 0, 0.8)'
      ..style.zIndex = '9999'
      ..style.display = 'flex'
      ..style.flexDirection = 'column'
      ..style.alignItems = 'center'
      ..style.justifyContent = 'center';

    final html.VideoElement videoElement = html.VideoElement()
      ..autoplay = true
      ..style.borderRadius = '10px';

    videoElement.onLoadedMetadata.listen((_) {
      // It was too big :/
      // videoElement.width = videoElement.videoWidth;
      // videoElement.height = videoElement.videoHeight;
      videoElement.width = 640;
      videoElement.height = 480;
    });

    final html.MediaStream stream =
        await html.window.navigator.getUserMedia(video: true);
    videoElement.srcObject = stream;

    final html.ButtonElement captureButton = html.ButtonElement()
      ..innerText = 'Capture'
      ..style.marginTop = '20px'
      ..style.padding = '10px 20px'
      ..style.fontSize = '16px'
      ..style.borderRadius = '5px'
      ..onClick.listen((_) async {
        final html.CanvasElement canvas = html.CanvasElement();
        final html.MediaStreamTrack track = stream.getVideoTracks()[0];
        final html.ImageCapture imageCapture = html.ImageCapture(track);
        final html.ImageBitmap image = await imageCapture.grabFrame();
        final ratio = image.width! / 640;
        canvas.width = 640;
        // Scale the height of canvas according to the ratio
        canvas.height = (image.height! / ratio).toInt();

        final html.CanvasRenderingContext2D context =
            canvas.getContext('2d') as html.CanvasRenderingContext2D;
        context.drawImageScaled(
            videoElement, 0, 0, canvas.width!, canvas.height!);
        final base64Image = canvas.toDataUrl().split(',').last;
        stream.getTracks().forEach((track) => track.stop());
        modal.remove();
        completer.complete(base64Image);
      });

    final html.ButtonElement cancelButton = html.ButtonElement()
      ..innerText = 'Cancel'
      ..style.marginTop = '10px'
      ..style.padding = '10px 20px'
      ..style.fontSize = '16px'
      ..style.borderRadius = '5px'
      ..onClick.listen((_) {
        stream.getTracks().forEach((track) => track.stop());
        modal.remove();
        completer.complete(null);
      });

    modal.append(videoElement);
    modal.append(captureButton);
    modal.append(cancelButton);
    html.document.body?.append(modal);

    return completer.future;
  }

  @override
  Future<String?> adjustDocumentCorners(String base64Image) {
    final completer = Completer<String?>();
    final html.DivElement modal = html.DivElement()
      ..style.position = 'fixed'
      ..style.left = '0'
      ..style.top = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.backgroundColor = 'rgba(0, 0, 0, 0.8)'
      ..style.zIndex = '9999'
      ..style.display = 'flex'
      ..style.flexDirection = 'column'
      ..style.alignItems = 'center'
      ..style.justifyContent = 'center';

    final html.CanvasElement canvas = html.CanvasElement()
      ..style.borderRadius = '10px';

    final context = canvas.getContext('2d') as html.CanvasRenderingContext2D;

    final html.ImageElement imageElement = html.ImageElement()
      ..src = 'data:image/jpeg;base64,$base64Image';

    void drawCornersAndLines(
        html.CanvasRenderingContext2D ctx, List<Map<String, int>> corners) {
      ctx.clearRect(0, 0, canvas.width!, canvas.height!);
      ctx.drawImage(imageElement, 0, 0);

      // ctx.clearRect(
      //     corners[0]['x']!,
      //     corners[0]['y']!,
      //     corners[1]['x']! - corners[0]['x']!,
      //     corners[1]['y']! - corners[0]['y']!);

      // Maybe there is a better way to do it..
      ctx.fillStyle = 'rgba(0, 0, 0, 0.5)';
      ctx.fillRect(0, 0, corners[1]['x']!, corners[0]['y']!);
      ctx.fillRect(corners[1]['x']!, 0, canvas.width! - corners[1]['x']!,
          canvas.height!);
      ctx.fillRect(
          0,
          corners[1]['y']!,
          canvas.width! - (canvas.width! - corners[1]['x']!),
          canvas.height! - corners[1]['y']!);
      ctx.fillRect(
          0,
          corners[0]['y']!,
          corners[0]['x']!,
          canvas.height! -
              corners[0]['y']! -
              (canvas.height! - corners[1]['y']!));

      ctx.strokeStyle = 'gray';
      ctx.lineWidth = 2;
      ctx.beginPath();

      ctx.moveTo(corners[0]['x']!, corners[0]['y']!);
      ctx.lineTo(corners[0]['x']!, corners[1]['y']!);
      ctx.lineTo(corners[1]['x']!, corners[1]['y']!);
      ctx.lineTo(corners[1]['x']!, corners[0]['y']!);
      ctx.lineTo(corners[0]['x']!, corners[0]['y']!);

      ctx.stroke();

      for (final corner in corners) {
        ctx.fillStyle = 'white';
        ctx.fillRect(corner['x']! - 5, corner['y']! - 5, 10, 10);
      }
    }

    var corners = [
      {'x': 50, 'y': 50},
      {'x': canvas.width! - 50, 'y': canvas.height! - 50},
    ];

    imageElement.onLoad.listen((event) {
      canvas.width = imageElement.width ?? 800;
      canvas.height = imageElement.height ?? 600;
      corners = [
        {'x': 50, 'y': 50},
        {'x': canvas.width! - 50, 'y': canvas.height! - 50},
      ];
      context.drawImage(imageElement, 0, 0);
      drawCornersAndLines(context, corners);
    });

    canvas.onMouseDown.listen((event) {
      final rect = canvas.getBoundingClientRect();
      final mouseX = event.client.x - rect.left;
      final mouseY = event.client.y - rect.top;

      int? selectedCornerIndex;
      for (int i = 0; i < corners.length; i++) {
        final corner = corners[i];
        final dx = mouseX - corner['x']!;
        final dy = mouseY - corner['y']!;
        if (dx * dx + dy * dy <= 25) {
          // 25 is 5*5 where 5 is the half side length of the corner square
          selectedCornerIndex = i;
          break;
        }
      }

      if (selectedCornerIndex != null) {
        onMouseMove(html.MouseEvent moveEvent) {
          final newMouseX = moveEvent.client.x - rect.left;
          final newMouseY = moveEvent.client.y - rect.top;
          corners[selectedCornerIndex!]['x'] = newMouseX.toInt();
          corners[selectedCornerIndex]['y'] = newMouseY.toInt();
          drawCornersAndLines(context, corners);
        }

        final moveSubscription = html.document.onMouseMove.listen(onMouseMove);

        onMouseUp(html.MouseEvent upEvent) {
          moveSubscription.cancel();
        }

        html.document.onMouseUp.listen(onMouseUp);
      }
    });

    final html.ButtonElement saveButton = html.ButtonElement()
      ..innerText = 'Save'
      ..style.marginTop = '20px'
      ..style.padding = '10px 20px'
      ..style.fontSize = '16px'
      ..style.borderRadius = '5px'
      ..onClick.listen((_) {
        final html.CanvasElement canvas = html.CanvasElement();

        final width = corners[1]['x']! - corners[0]['x']!;
        final height = corners[1]['y']! - corners[0]['y']!;
        canvas.width = width;
        canvas.height = height;

        final html.CanvasRenderingContext2D context =
            canvas.getContext('2d') as html.CanvasRenderingContext2D;

        // Now I plot the image bounded by corners to canvas
        context.drawImageScaledFromSource(imageElement, corners[0]['x']!,
            corners[0]['y']!, width, height, 0, 0, width, height);

        final base64Image = canvas.toDataUrl().split(',').last;

        modal.remove();
        // Process and save the adjusted image if necessary
        completer.complete(
            base64Image); // Replace with actual adjusted image data if needed
      });

    final html.ButtonElement cancelButton = html.ButtonElement()
      ..innerText = 'Cancel'
      ..style.marginTop = '10px'
      ..style.padding = '10px 20px'
      ..style.fontSize = '16px'
      ..style.borderRadius = '5px'
      ..onClick.listen((_) {
        modal.remove();
        completer.complete(null);
      });

    modal.append(canvas);
    modal.append(saveButton);
    modal.append(cancelButton);
    html.document.body?.append(modal);

    return completer.future;
  }

  @override
  Future<String> adjustDocumentContrast(String base64Image, double contrast) {
    final completer = Completer<String>();
    final html.ImageElement imageElement = html.ImageElement()
      ..src = 'data:image/jpeg;base64,$base64Image';

    imageElement.onLoad.listen((event) {
      final html.CanvasElement canvas = html.CanvasElement();

      canvas.width = imageElement.width;
      canvas.height = imageElement.height;

      final html.CanvasRenderingContext2D context =
          canvas.getContext('2d') as html.CanvasRenderingContext2D;

      context.filter = "contrast($contrast%)";
      context.drawImage(imageElement, 0, 0);

      // Now I plot the image bounded by corners to canvas

      final result = canvas.toDataUrl().split(',').last;
      completer.complete(result);
    });

    return completer.future;
  }

  @override
  void copyImageToClipboard(String base64Image) async {
    // Good idea, but not works, see issue https://github.com/dart-lang/sdk/issues/44816
    // final dataTransfer = html.DataTransfer();
    // final imageData = base64Decode(base64Image);

    // dataTransfer.setData('image/png', html.Blob([imageData]).toString());
    // await html.window.navigator.clipboard!.write(dataTransfer);

    // Copies image to clipboard as base64
    await html.window.navigator.clipboard!.writeText(base64Image);
  }
}
