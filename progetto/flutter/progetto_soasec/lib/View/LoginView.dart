import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progetto_soasec/Controller/Controller.dart';
import 'package:progetto_soasec/View/Theme.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  String _error_message = "";
  bool _error = false;

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
          BoxShadow(
            color: lineColor,
            blurRadius: 22,
          )
        ]),
        height: 300,
        width: 250,
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 12),
                Text(
                  "Benvenuto",
                  style: GoogleFonts.montserrat(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 0,
                ),
                Text(
                  "Accedi per iniziare",
                  style: GoogleFonts.montserrat(fontSize: 18, color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Container(
                child: new TextField(
              controller: _usernameTextController,
              decoration: new InputDecoration(
                focusedBorder: new OutlineInputBorder(borderSide: new BorderSide(color: lineColor)),
                enabledBorder: new OutlineInputBorder(borderSide: new BorderSide(color: lineColor)),
                labelText: 'Username',
                labelStyle: TextStyle(color: lineColor),
                prefixIcon: Icon(
                  Icons.person,
                  color: lineColor,
                ),
                prefixText: ' ',
              ),
            )),
            SizedBox(height: 16),
            Container(
              child: new TextField(
                obscureText: true,
                controller: _passwordTextController,
                decoration: new InputDecoration(
                  focusedBorder: new OutlineInputBorder(borderSide: new BorderSide(color: lineColor)),
                  enabledBorder: new OutlineInputBorder(borderSide: new BorderSide(color: lineColor)),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: lineColor),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: lineColor,
                  ),
                  prefixText: ' ',
                ),
              ),
            ),
            SizedBox(
              height: 32,
              child: _error
                  ? Container(
                      alignment: Alignment.center,
                      child: Text(
                        _error_message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(fontSize: 12, color: Colors.red),
                      ),
                    )
                  : Container(),
            ),
            ElevatedButton(
                style: buttonStyle,
                onPressed: () async {
                  if (_loading) return;
                  setState(() {
                    _loading = true;
                  });
                  _error = false;
                  final username = _usernameTextController.text;
                  final password = _passwordTextController.text;
                  if (username == null || username == "") {
                    _error = true;
                    _error_message = "Ricordati di settare l'username";
                  }
                  if (password == null || password == "") {
                    _error = true;
                    _error_message = "Ricordati di settare la password";
                  }

                  if (!_error) {
                    final result = await Controller().login(username: _usernameTextController.text, password: _passwordTextController.text);
                    if (!result) {
                      _error = true;
                      _error_message = "Impossibile effettuare il login";
                    } else {
                      Navigator.of(context).pop(true);
                    }
                  }

                  setState(() {
                    _loading = false;
                  });
                },
                child: _loading
                    ? CircularProgressIndicator()
                    : Text(
                        "Login",
                        style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w500),
                      ))
          ],
        ),
      ),
    );
  }
}
