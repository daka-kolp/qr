import 'dart:convert';

import 'package:test/test.dart';

import 'package:qr/src/data/models/user_model.dart';
import 'package:qr/src/domain/entities/user.dart';

import '../../../fixtures/fixture_reader.dart';

main() {
  final userModel = UserModel(
    id: 'NAME1234567890',
    name: 'Name Surname',
    email: 'user@gmail.com',
    position: 'position',
    phone: '+380986612255',
    status: UserStatus.user,
  );

  test(
    'UserModel type',
    () {
      expect(userModel, isA<UserModel>());
    },
  );

  group('fromJson', () {
    test(
      'get model from jsonList',
      () {
        final listJson = json.decode(fixture('all_users.json'));
        final jsonModel =
            listJson.where(((obj) => obj['id'] == 'NAME1234567890')).first;

        final result = UserModel.fromJson(jsonModel);
        expect(result, userModel);
      },
    );
  });

  group('toJson', () {
    test(
      'convert model to Json',
      () {
        final result = userModel.toJson();
        final expectedUserJson = {
          "id": "NAME1234567890",
          "name": "Name Surname",
          "email": "user@gmail.com",
          "position": "position",
          "phone": "+380986612255",
          "userStatus": 3
        };
        expect(result, expectedUserJson);
      },
    );
  });
}
