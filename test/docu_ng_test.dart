import 'package:flutter_test/flutter_test.dart';
import 'package:docu_ng/docu_ng.dart';
import 'package:docu_ng/docu_ng_platform_interface.dart';
import 'package:docu_ng/docu_ng_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDocuNgPlatform
    with MockPlatformInterfaceMixin
    implements DocuNgPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DocuNgPlatform initialPlatform = DocuNgPlatform.instance;

  test('$MethodChannelDocuNg is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDocuNg>());
  });

  test('getPlatformVersion', () async {
    DocuNg docuNgPlugin = DocuNg();
    MockDocuNgPlatform fakePlatform = MockDocuNgPlatform();
    DocuNgPlatform.instance = fakePlatform;

    expect(await docuNgPlugin.getPlatformVersion(), '42');
  });
}
