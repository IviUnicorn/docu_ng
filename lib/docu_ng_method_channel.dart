import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'docu_ng_platform_interface.dart';

/// An implementation of [DocuNgPlatform] that uses method channels.
class MethodChannelDocuNg extends DocuNgPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('docu_ng');

  @override
  Future<String?> scanDocument() async {
    final image = await methodChannel.invokeMethod<String>('scanDocument');
    return image;
  }
}
