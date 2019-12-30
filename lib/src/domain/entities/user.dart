import 'package:meta/meta.dart';

class User {
  final String id;
  final String name;
  final String position;
  final String phone;
  final UserStatus status;

  User({
    @required this.id,
    @required this.name,
    @required this.position,
    @required this.phone,
    @required this.status,
  })  : assert(id != null),
        assert(name != null),
        assert(position != null),
        assert(phone != null),
        assert(status != null);

  @override
  bool operator ==(Object other) =>
      other is User &&
      runtimeType == other.runtimeType &&
      id == other.id &&
      name == other.name &&
      position == other.position &&
      phone == other.phone &&
      status == other.status;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      position.hashCode ^
      phone.hashCode ^
      status.hashCode;
}

class UserStatus {
  final int value;

  UserStatus._(this.value);

  factory UserStatus(int status) {
    switch (status) {
      case 1:
        return superAdmin;
      case 2:
        return admin;
      case 3:
        return user;
    }
    throw ArgumentError();
  }

  static UserStatus get superAdmin {
    return UserStatus._(1);
  }

  static UserStatus get admin {
    return UserStatus._(2);
  }

  static UserStatus get user {
    return UserStatus._(3);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatus &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
