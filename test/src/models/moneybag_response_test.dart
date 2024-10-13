import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moneybag_flutter/src/domain/moneybag_response.dart';

import '../../fixture/fixture.dart';

void main() {
  test('moneybag failures ...', () {
    final data = fixture("moneybag_failures_list.json");

    final items = (jsonDecode(data) as List) //
        .map((e) => MoneybagFailures.fromMap(e));

    for (var element in items) {
      expect(element, isA<MoneybagFailures>());
    }
  });

  test("on success", () {
    final data = fixture("moneybag_success.json");
    final success = MoneybagSuccessResponse.fromMap(jsonDecode(data));
    expect(success, isA<MoneybagSuccessResponse>());
  });
}
