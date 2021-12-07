import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progetto_soasec/Controller/Controller.dart';
import 'package:progetto_soasec/View/Theme.dart';

class NuovoCandidatoView extends StatefulWidget {
  @override
  _NuovoCandidatoViewState createState() => _NuovoCandidatoViewState();
}

class _NuovoCandidatoViewState extends State<NuovoCandidatoView> {
  TextEditingController _nomeTextController = TextEditingController();
  TextEditingController _cognomeTextController = TextEditingController();
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
                  "Nuovo Candidato",
                  style: GoogleFonts.montserrat(fontSize: 18, color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Container(
                child: new TextField(
              controller: _nomeTextController,
              decoration: new InputDecoration(
                focusedBorder: new OutlineInputBorder(borderSide: new BorderSide(color: lineColor)),
                enabledBorder: new OutlineInputBorder(borderSide: new BorderSide(color: lineColor)),
                labelText: 'Nome',
                labelStyle: TextStyle(color: lineColor),
              ),
            )),
            SizedBox(height: 16),
            Container(
              child: new TextField(
                controller: _cognomeTextController,
                decoration: new InputDecoration(
                  focusedBorder: new OutlineInputBorder(borderSide: new BorderSide(color: lineColor)),
                  enabledBorder: new OutlineInputBorder(borderSide: new BorderSide(color: lineColor)),
                  labelText: 'Cognome',
                  labelStyle: TextStyle(color: lineColor),
                ),
              ),
            ),
            SizedBox(
              height: 64,
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
                  final nome = _nomeTextController.text;
                  final cognome = _cognomeTextController.text;
                  if (nome == null || nome == "") {
                    _error = true;
                    _error_message = "Ricordati di settare l'nome";
                  }
                  if (cognome == null || cognome == "") {
                    _error = true;
                    _error_message = "Ricordati di settare il cognome";
                  }

                  if (!_error) {
                    final result = await Controller().crea_nuovo_candidato(nome: nome, cognome: cognome);
                    if (result.error) {
                      _error = true;
                      _error_message = result.message;
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
                        "Crea candidato",
                        style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w500),
                      ))
          ],
        ),
      ),
    );
  }
}
