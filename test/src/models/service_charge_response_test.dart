import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moneybag_flutter/src/domain/service_charge_response.dart';

import '../../fixture/fixture.dart';

void main() {
  test('service charge response ...', () {
    final data = fixture("service_charge_response.json");
    final success = ServiceChargeResponse.fromMap(jsonDecode(data));
    expect(success, isA<ServiceChargeResponse>());
  });
}
