class APIHelper {
  static final String _back_end_base_url = "http://localhost";
  static final String _back_end_port = "3050";
  static final String _keycloak_base_url = "http://keycloak";
  static final String _keycloak_port = "8080";
  static final String keycloak_client_id = "secure-nodejs-application";
  static final String keycloak_client_secret = "e51bfd3e-6634-4319-bafa-e8022ee9f03b";
  static final String login_url = _keycloak_base_url + ":" + _keycloak_port + "/auth/realms/SOASEC/protocol/openid-connect/token";

  static final String lista_candidati_url = _back_end_base_url + ":" + _back_end_port + "/anonymous/lista-candidati";
  static String vota_candidato({required String id_candidato}) {
    return _back_end_base_url + ":" + _back_end_port + "/user/vota/" + id_candidato;
  }

  static final String crea_nuovo_candidato = _back_end_base_url + ":" + _back_end_port + "/admin/creazione-nuovo-candidato";
  static String cancella_candidato({required String id_candidato}) {
    return _back_end_base_url + ":" + _back_end_port + "/admin/cancella-candidato/" + id_candidato;
  }
}
