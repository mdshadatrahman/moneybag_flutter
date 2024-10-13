import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moneybag_flutter/src/domain/session_info.dart';

import '../../fixture/fixture.dart';

void main() {
  test('session info ...', () {
    final data = fixture("session_info.json");

    final sessionInfo = SessionInfo.fromMap(jsonDecode(data));
    expect(sessionInfo, isA<SessionInfo>());
    expect(sessionInfo.banks.length, 4);
    expect(sessionInfo.mfs.length, 3);
  });
}
