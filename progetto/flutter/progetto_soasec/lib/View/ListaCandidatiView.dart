import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progetto_soasec/Controller/Controller.dart';
import 'package:progetto_soasec/Model/ResponseData.dart';
import 'package:progetto_soasec/Model/UserRole.dart';
import 'package:progetto_soasec/View/FutureDialog.dart';
import 'package:progetto_soasec/View/LoginView.dart';
import 'package:progetto_soasec/View/NuovoCandidatoView.dart';
import 'package:progetto_soasec/View/Theme.dart';

class ListaCandidatiView extends StatefulWidget {
  @override
  _ListaCandidatiViewState createState() => _ListaCandidatiViewState();
}

class _ListaCandidatiViewState extends State<ListaCandidatiView> {
  late Future _fetchListaCandidati;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    _fetchListaCandidati = Controller().recupero_lista_candidati();
  }

  Widget _waitingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _errorWidget(String title, String subtitle, bool showButton) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 300,
        maxWidth: 300,
      ),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: !showButton
              ? [
                  BoxShadow(
                    color: lineColor,
                    blurRadius: 22,
                  )
                ]
              : []),
      child: Column(
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
            size: 34,
          ),
          SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: showButton ? 24 : 0),
          !showButton
              ? Container()
              : ElevatedButton(
                  onPressed: () {
                    setState(() {
                      loadData();
                    });
                  },
                  style: buttonStyle,
                  child: Text(
                    "Riprova!",
                    style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w500),
                  ))
        ],
      ),
    );
  }

  Widget _errorMessageWidget(String message) {
    return Column(
      children: [
        Text(message),
        SizedBox(
          height: 10,
        ),
        TextButton(
            onPressed: () {
              setState(() {
                loadData();
              });
            },
            child: Text("Riprova"))
      ],
    );
  }

  bool _alreadyVoted(List<dynamic> votanti) {
    final user = Controller().user;

    if (user != null && votanti.contains(user.username)) {
      return true;
    }
    return false;
  }

  Widget _buildListView(dynamic data) {
    List<dynamic> candidati = data;
    return Container(
      child: candidati.length == 0
          ? Container(
              child: Center(
                child: Text("Nessun candidato da votare, richiesto privilegio admin per poter creare un nuovo candidato", textAlign: TextAlign.center,style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w500),),
              ),
            )
          : ListView.separated(
              itemCount: candidati.length,
              itemBuilder: (context, index) {
                final candidato = candidati[index];
                final String nome = candidato["nome"];
                final String cognome = candidato["cognome"];
                final List<dynamic> votanti = candidato["votanti"];
                final id_candidato = candidato["_id"];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                          top: index == 0 ? BorderSide(color: lineColor, width: 0.5) : BorderSide.none,
                          bottom: BorderSide(color: lineColor, width: 0.5)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nome + " " + cognome,
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "voti: " + votanti.length.toString(),
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          (Controller().user?.isUserRole(Role.user) ?? true) && Controller().isLoggedIn()
                              ? ElevatedButton(
                                  style: buttonStyle,
                                  onPressed: _alreadyVoted(votanti)
                                      ? null
                                      : () async {
                                          if (_loading) return;
                                          _loading = true;
                                          if (Controller().isLoggedIn()) {
                                            final result = await showFutureDialog<ResponseData>(
                                                context, Controller().vota_candidato(id_candidato: id_candidato));

                                            if (result != null && !result.error) {
                                              setState(() {
                                                loadData();
                                              });
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return Center(
                                                      child: _errorWidget(
                                                          "Impossibile eseguire l'operazione", result?.message ?? "Errore generico", false),
                                                    );
                                                  });
                                            }
                                          }
                                          _loading = false;
                                        },
                                  child: Text(
                                    "Vota!",
                                    style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w500),
                                  ))
                              : Container(),
                          (Controller().user?.isUserRole(Role.admin) ?? false)
                              ? IconButton(
                                  onPressed: () async {
                                    if (_loading) return;
                                    _loading = true;
                                    final result = await showFutureDialog<ResponseData>(
                                        context, Controller().cancella_candidato(id_candidato: id_candidato));

                                    if (result != null && !result.error) {
                                      setState(() {
                                        loadData();
                                      });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return Center(
                                              child: _errorWidget(
                                                  "Impossibile eseguire l'operazione", result?.message ?? "Errore generico", false),
                                            );
                                          });
                                    }
                                    _loading = false;
                                  },
                                  icon: Icon(Icons.delete))
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 8,
                );
              },
            ),
    );
  }

  Widget _titleWidget() {
    final user = Controller().user;
    var wellcomeMessage = "Ciao amico!";
    if (user != null && Controller().isLoggedIn()) {
      wellcomeMessage = "Ciao " + user.name + "!";
    }
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wellcomeMessage,
                style: GoogleFonts.montserrat(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Vota i candidati che preferisci",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
      Controller().isLoggedIn()
          ? Positioned(
              right: 32,
              top: -20,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    Controller().user = null;
                  });
                },
                icon: Icon(Icons.logout),
              ))
          : Container()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 82,
          ),
          _titleWidget(),
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder(
                future: _fetchListaCandidati,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (!snapshot.hasData) {
                      return _errorWidget("Impossibile raggiungere il server", "Assicurati che sia attivo e poi riprova", true);
                    } else {
                      final ResponseData data = snapshot.data as ResponseData;
                      if (data.error) {
                        return _errorMessageWidget(data.message);
                      }
                      return _buildListView(data.data as List<dynamic>);
                    }
                  }
                  return _waitingWidget();
                },
              ),
            ),
          ),
          (Controller().user?.isUserRole(Role.admin) ?? false)
              ? Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Container(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () async {
                          if (_loading) return;
                          _loading = true;
                          final result = await showDialog(
                              context: context,
                              barrierColor: Colors.transparent,
                              barrierDismissible: true,
                              builder: (context) {
                                return Center(
                                  child: NuovoCandidatoView(),
                                );
                              });
                          if (result != null && result) {
                            setState(() {
                              loadData();
                            });
                          }
                          _loading = false;
                        },
                        child: Text(
                          "Crea nuovo candidato!",
                          style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w500),
                        )),
                  ),
                )
              : !Controller().isLoggedIn()
                  ? Container(
                      height: 100,
                      alignment: Alignment.center,
                      child: Container(
                        height: 50,
                        width: 250,
                        child: ElevatedButton(
                            style: buttonStyle,
                            onPressed: () async {
                              if (_loading) return;
                              _loading = true;
                              final result = await showDialog(
                                  context: context,
                                  barrierColor: Colors.transparent,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return Center(
                                      child: LoginView(),
                                    );
                                  });
                              if (result != null && result) {
                                setState(() {});
                              }
                              _loading = false;
                            },
                            child: Text(
                              "Effettua il login per procedere",
                              style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w500),
                            )),
                      ),
                    )
                  : Container()
        ],
      ),
    );
  }
}
