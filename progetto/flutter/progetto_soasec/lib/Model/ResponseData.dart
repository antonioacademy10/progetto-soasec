

class ResponseData {

  int statusCode;
  bool error;
  String message;
  dynamic? data;

  ResponseData({required this.statusCode, required this.error, required this.message, this.data});

}