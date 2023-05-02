import 'package:flutter/material.dart';
import 'package:medicine_app/mainpage.dart';
import '../util/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: Container(
        margin: EdgeInsets.all(20 * fem),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // loginseW (5:12)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 51 * fem),
              child: Text(
                'LogIn',
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: 40 * fem,
                  fontWeight: FontWeight.w700,
                  height: 1.2125 * fem / fem,
                  color: const Color(0xff000000),
                ),
              ),
            ), // Login Text
            inputBox(context, "USERNAME", Icons.account_circle_outlined),
            inputBox(context, "PASSWORD", Icons.lock_outline),
            SizedBox(height: 10*fem),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(0xff8a60ff)),
                  minimumSize:
                      MaterialStatePropertyAll(Size(double.infinity, 40 * fem)),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  )),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainPage(),
                  ),
                );
              },
              child: Text(
                'LogIn',
                textAlign: TextAlign.center,
                style: SafeGoogleFont(
                  'Nunito',
                  fontSize: 22 * fem,
                  fontWeight: FontWeight.w400,
                  height: 1.3625 * fem / fem,
                  color: const Color(0xffffffff),
                ),
              ),
            ), // Login Button
            forgotOrSignUpText("Forgot password?", context, 220),
            forgotOrSignUpText("Sign up", context, 285),
          ],
        ),
      ),
    );
  }
}

Widget forgotOrSignUpText(var text, var context, var leftMargin) {
  double baseWidth = 390;
  double fem = MediaQuery.of(context).size.width / baseWidth;
  double ffem = fem * 0.97;

  return Container(
    // forgotpasswordEYv (5:531)
    margin: EdgeInsets.fromLTRB(leftMargin * fem, 0 * fem, 0 * fem, 0 * fem),
    child: TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Text(
        text,
        style: SafeGoogleFont(
          'Inter',
          fontSize: 14 * ffem,
          fontWeight: FontWeight.w700,
          height: 1.25 * ffem / fem,
          color: const Color(0xff8a60ff),
        ),
      ),
    ),
  );
}

Widget inputBox(var context, var text, var icon) {
  double baseWidth = 390;
  double fem = MediaQuery.of(context).size.width / baseWidth;

  return Container(
    margin: EdgeInsets.only(top: 10*fem),
    child: TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 30*fem,),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff8a60ff), width: 1.0),
        ),
        border: const OutlineInputBorder(),
        hintText: text,
      ),
    ),
  );
}

