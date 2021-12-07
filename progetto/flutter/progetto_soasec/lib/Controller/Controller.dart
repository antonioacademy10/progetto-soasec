import 'package:dio/dio.dart';
import 'package:progetto_soasec/Model/Helper.dart';
import 'package:progetto_soasec/Model/ResponseData.dart';
import 'package:progetto_soasec/Model/UserModel.dart';
import 'package:progetto_soasec/Model/UserRole.dart';

class Controller {
  static final Controller _singleton = Controller._internal();

  UserModel? user;

  factory Controller() {
    return _singleton;
  }

  Controller._internal();

  Future<bool> login({required String username, required String password}) async {
    final dio = Dio();

    final options = new Options(contentType: Headers.formUrlEncodedContentType, validateStatus: (_) => true);

    final response = await dio.post(
      APIHelper.login_url,
      data: {
        "grant_type": "password",
        "client_id": APIHelper.keycloak_client_id,
        "client_secret": APIHelper.keycloak_client_secret,
        "username": username,
        "password": password
      },
      options: options,
    );

    if (response.statusCode != 200) {
      return false;
    }
    final data = response.data;
    final token = data["access_token"];
    this.user = UserModel.fromToken(token);
    return true;
  }

  bool isLoggedIn() {
    return user != null;
  }

  Future<ResponseData> crea_nuovo_candidato({required String nome, required String cognome}) async {
    if (this.user == null || !this.user!.isUserRole(Role.admin)) {
      return ResponseData(
        message: "non disponi delle autorizzazioni necessarie",
        error: true,
        statusCode: 401,
      );
    }
    final dio = Dio();
    final options = new Options(
        contentType: Headers.jsonContentType,
        validateStatus: (_) => true,
        headers: {"Authorization": "Bearer" + " " + (user?.token ?? " ")});
    final response = await dio.post(
      APIHelper.crea_nuovo_candidato,
      data: {"nome": nome, "cognome": cognome},
      options: options,
    );
    if (response.statusCode != 200) {
      return ResponseData(
        message: "impossibile eseguire la richiesta",
        error: true,
        statusCode: response.statusCode!,
      );
    }
    final data = response.data;
    return ResponseData(
      message: data["message"],
      error: false,
      statusCode: response.statusCode ?? 200,
    );
  }

  Future<ResponseData> recupero_lista_candidati() async {
    final dio = Dio();
    final options = new Options(
        contentType: Headers.jsonContentType,
        validateStatus: (_) => true,
        headers: {"Authorization": "Bearer" + " " + (user?.token ?? "empty-token")});
    final response = await dio.get(APIHelper.lista_candidati_url, options: options);

    if (response.statusCode != 200) {
      return ResponseData(
        message: "impossibile eseguire la richiesta",
        error: true,
        statusCode: response.statusCode!,
      );
    }
    final data = response.data;
    return ResponseData(message: data["message"], error: false, statusCode: response.statusCode ?? 200, data: data["data"]);
  }

  Future<ResponseData> cancella_candidato({required String id_candidato}) async {
    if (this.user == null || !this.user!.isUserRole(Role.admin)) {
      return ResponseData(
        message: "non disponi delle autorizzazioni necessarie",
        error: true,
        statusCode: 401,
      );
    }

    final dio = Dio();
    final options = new Options(
        contentType: Headers.jsonContentType,
        validateStatus: (_) => true,
        headers: {"Authorization": "Bearer" + " " + (user?.token ?? " ")});
    final response = await dio.get(APIHelper.cancella_candidato(id_candidato: id_candidato), options: options);

    if (response.statusCode != 200) {
      return ResponseData(
        message: "impossibile eseguire la richiesta",
        error: true,
        statusCode: response.statusCode!,
      );
    }
    final data = response.data;
    return ResponseData(
      message: data["message"],
      error: false,
      statusCode: response.statusCode ?? 200,
    );
  }

  Future<ResponseData> vota_candidato({required String id_candidato}) async {
    if (this.user == null || !this.user!.isUserRole(Role.user)) {
      return ResponseData(
        message: "non disponi delle autorizzazioni necessarie",
        error: true,
        statusCode: 401,
      );
    }

    final dio = Dio();
    final options = new Options(
        contentType: Headers.jsonContentType,
        validateStatus: (_) => true,
        headers: {"Authorization": "Bearer" + " " + (this.user?.token ?? " ")});
    final response = await dio.get(APIHelper.vota_candidato(id_candidato: id_candidato), options: options);

    if (response.statusCode != 200) {
      return ResponseData(
        message: "impossibile eseguire la richiesta",
        error: true,
        statusCode: response.statusCode!,
      );
    }
    final data = response.data;
    return ResponseData(
      message: data["message"],
      error: false,
      statusCode: response.statusCode ?? 200,
    );
  }
}
