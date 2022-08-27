import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geraetepruefung_ff_liekwegen/main.dart';

class loginPage extends StatefulWidget {
  loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String errorText = '';

  Future<void> loginUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
      if (e.code == 'user-not-found') {
        setState(() {
          errorText = 'Kein Benutzer mit dieser Email-Adresse gefunden';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          errorText = 'Falsches Passwort für diesen Benutzer';
        });
      } else if (e.code == "user-disabled") {
        setState(() {
          errorText =
              'Benutzer wurde gesperrt\nWenden Sie sich an ihren Administrator';
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.red[400],
        title: Row(
          children: const [
            Icon(
              Icons.handyman,
              color: Colors.amber,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Geräte & Fahrzeugprüfungen\nder Freiwilligen Feuerwehr Liekwegen',
                style: TextStyle(color: Colors.amber),
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Einloggen',
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SizedBox(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'E-Mail'),
                      controller: emailController,
                    ),
                    width: MediaQuery.of(context).size.width / 3,
                  )),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SizedBox(
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Passwort'),
                      controller: passwordController,
                    ),
                    width: MediaQuery.of(context).size.width / 3,
                  )),
              errorText == ''
                  ? const SizedBox(
                      width: 0,
                      height: 0,
                    )
                  : Text(
                      errorText,
                      style: TextStyle(
                          color: Colors.red[400],
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: SizedBox(
                    height: 50,
                    width: 138,
                    child: ElevatedButton(
                        onPressed: () => loginUser(
                            emailController.text, passwordController.text),
                        child: Row(
                          children: const [
                            Icon(Icons.login),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Einloggen'),
                            )
                          ],
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> logOutUser(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => loginPage()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Ausloggen nicht möglich\n$e'))
    );
  }
}
