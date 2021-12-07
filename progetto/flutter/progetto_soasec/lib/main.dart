import 'package:flutter/material.dart';
import 'package:progetto_soasec/View/ListaCandidatiView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Progetto SOASEC',
        debugShowCheckedModeBanner: false,
        home: Center(
          child: Container(
              height: 812,
              width: 375,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 84),
                    child: ListaCandidatiView(),
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: Image.asset("assets/iphoneframe.png"),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
