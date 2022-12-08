import 'package:foto_budka/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                color: Color(0xffffffff),
                gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Color(0x49B2FCFF), Colors.lightBlueAccent])),
          ),
          Align(
            alignment: FractionalOffset.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Image(
                  image: AssetImage('images/logo.png'),
                  width: 150,
                ),
                const Padding(padding: EdgeInsets.only(top: 15.0)),
                Text(Strings.appTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                    ))),
                const Padding(padding: EdgeInsets.only(top: 15.0)),
                Text(
                    'Aplikacja pozwalająca na \n stworzenie wyjątkowej pamiątki \n w postaci zdjęć z budki',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ))),
              ],
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 35,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 100, right: 100),
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.blue))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlue),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(top: 12.0, bottom: 12.0))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LandingScreen()));
                      },
                      child: const Text(
                        'Zaczynajmy!',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    )),
              ))
        ],
      ),
    );
  }
}
