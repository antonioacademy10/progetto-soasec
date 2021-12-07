import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

Future<T?> showFutureDialog<T>(context, Future function) async {
  CustomProgressDialog progressDialog =
      CustomProgressDialog(context, blur: 1, backgroundColor: Colors.white.withOpacity(0.1), dismissable: false);

  ///You can set Loading Widget using this function
  progressDialog.setLoadingWidget(CircularProgressIndicator());
  progressDialog.show();

  final result = await function;
  progressDialog.dismiss();
  return result;
}
