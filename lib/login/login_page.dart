import 'package:flutter/material.dart';

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
    double ffem = fem * 0.97;

    return Scaffold(
      body: SafeArea(
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
                  fontSize: 40 * ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.2125 * ffem / fem,
                  color: const Color(0xff000000),
                ),
              ),
            ),
            inputBox(context, "user", "USERNAME"),
            inputBox(context, "lock", "PASSWORD"),
            Container(
              // signupbuttonPoC (5:298)
              margin: EdgeInsets.fromLTRB(27*fem, 0*fem, 27*fem, 22*fem),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom (
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: double.infinity,
                  height: 40*fem,
                  decoration: BoxDecoration (
                    color: const Color(0xffa98aff),
                    borderRadius: BorderRadius.circular(20*fem),
                  ),
                  child: Center(
                    child: Center(
                      child: Text(
                        'LogIn',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont (
                          'Nunito',
                          fontSize: 22*ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.3625*ffem/fem,
                          color: const Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
    margin: EdgeInsets.fromLTRB(leftMargin*fem, 0*fem, 0*fem, 0*fem),
    child: TextButton(
      onPressed: () {},
      style: TextButton.styleFrom (
        padding: EdgeInsets.zero,
      ),
      child: Text(
        text,
        style: SafeGoogleFont (
          'Inter',
          fontSize: 14*ffem,
          fontWeight: FontWeight.w700,
          height: 1.25*ffem/fem,
          color: const Color(0xff8a60ff),
        ),
      ),
    ),
  );
}

Widget inputBox(var context, var image, var text) {
  double baseWidth = 390;
  double fem = MediaQuery.of(context).size.width / baseWidth;
  double ffem = fem * 0.97;

  return Container(
    // usernamezDL (5:70)
    margin: EdgeInsets.fromLTRB(27 * fem, 0 * fem, 27 * fem, 19.15 * fem),
    padding: EdgeInsets.fromLTRB(15.33 * fem, 12 * fem, 15.33 * fem, 11.08 * fem),
    width: double.infinity,
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xff8a60ff)),
      borderRadius: BorderRadius.circular(4 * fem),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          // userVA6 (5:73)
          margin:
              EdgeInsets.fromLTRB(0 * fem, 0.04 * fem, 22.33 * fem, 0 * fem),
          width: 13.33 * fem,
          height: 14.36 * fem,
          child: Image.asset(
            'image/$image.png',
            width: 13.33 * fem,
            height: 14.36 * fem,
          ),
        ),
        Text(
          // usernamezsY (5:72)
          text,
          textAlign: TextAlign.center,
          style: SafeGoogleFont(
            'Montserrat',
            fontSize: 14 * ffem,
            fontWeight: FontWeight.w300,
            height: 1.4285714286 * ffem / fem,
            color: const Color(0xff000000),
          ),
        ),
      ],
    ),
  );
}
