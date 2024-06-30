import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'docu_ng_method_channel.dart';

abstract class DocuNgPlatform extends PlatformInterface {
  /// Constructs a DocuNgPlatform.
  DocuNgPlatform() : super(token: _token);

  static final Object _token = Object();

  static DocuNgPlatform _instance = MethodChannelDocuNg();

  /// The default instance of [DocuNgPlatform] to use.
  ///
  /// Defaults to [MethodChannelDocuNg].
  static DocuNgPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DocuNgPlatform] when
  /// they register themselves.
  static set instance(DocuNgPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> scanDocument() {
    throw UnimplementedError('scamDocument() has not been implemented.');
  }

  Future<String?> adjustDocumentCorners(String base64Image) async {
    throw UnimplementedError('adjustDocumentCorners() has not been implemented.');
  }

  Future<String> adjustDocumentContrast(String base64Image, double contrast) {
    throw UnimplementedError('adjustDocumentContrast() has not been implemented.');
  }
}
