import 'package:jwt_decode/jwt_decode.dart';
import 'package:progetto_soasec/Model/Helper.dart';
import 'package:progetto_soasec/Model/UserRole.dart';

class UserModel {
  late String username;
  late String name;
  late String surname;
  late List<dynamic> _roles;
  late String token;

  UserModel({required this.username, required this.name, required this.surname, required this.token, required List<String> roles}) {
    this._roles = _roles;
  }

  UserModel.fromToken(String token) {
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    this.token = token;
    this.username = payload["preferred_username"];
    this.name = payload["given_name"];
    this.surname = payload["family_name"];
    this._roles = payload["resource_access"][APIHelper.keycloak_client_id]["roles"];
  }

  bool isUserRole(Role role) {
    var roleString = "anonymous";
    switch (role) {
      case Role.admin:
        roleString = "admin";
        break;
      case Role.user:
        roleString = "user";
        break;
    }

    return this._roles.contains(roleString);
  }

  bool isTokenValid() {
    return Jwt.isExpired(this.token);
  }
}
