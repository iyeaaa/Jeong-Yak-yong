import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../util/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save(); // Form 전체의 state값을 저장하고 onSaved 호출
    }
  }

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
                'Sign Up',
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: 40 * fem,
                  fontWeight: FontWeight.w700,
                  height: 1.2125 * fem / fem,
                  color: const Color(0xff000000),
                ),
              ),
            ), // SignUp Text
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10 * fem),
                    child: TextFormField(
                      validator: (v) {
                        if (v!.isEmpty || v.length < 4) {
                          return '4자 이상의 사용자 이름을 입력하세요';
                        }
                        return null;
                      },
                      onSaved: (value) => userName = value!,
                      onChanged: (value) => userName = value,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.account_circle_outlined,
                          size: 30 * fem,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff8a60ff), width: 1.0),
                        ),
                        border: const OutlineInputBorder(),
                        hintText: "USERNAME",
                      ),
                    ),
                  ), // USERNAME BOX
                  Container(
                    margin: EdgeInsets.only(top: 10 * fem),
                    child: TextFormField(
                      validator: (v) {
                        String emailRegix =
                            '^[a-zA-Z0-9+-\\_.]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+\$';
                        if (v!.isEmpty || !RegExp(emailRegix).hasMatch(v)) {
                          return '유효한 이메일 주소를 입력하세요';
                        }
                        return null;
                      },
                      onSaved: (value) => userEmail = value!,
                      onChanged: (value) => userEmail = value,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          size: 30 * fem,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff8a60ff), width: 1.0),
                        ),
                        border: const OutlineInputBorder(),
                        hintText: "EMAIL",
                      ),
                    ),
                  ), // EMAIL BOX,
                  Container(
                    margin: EdgeInsets.only(top: 10 * fem),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      validator: (v) {
                        if (v!.isEmpty || v.length < 6) {
                          return '6자 이상의 비밀번호를 입력하세요';
                        }
                        return null;
                      },
                      onSaved: (value) => userPassword = value!,
                      onChanged: (value) => userPassword = value,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          size: 30 * fem,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff8a60ff), width: 1.0),
                        ),
                        border: const OutlineInputBorder(),
                        hintText: "PASSWORD",
                      ),
                    ),
                  ), // PASSWORD BOX
                ],
              ),
            ), // PASSWORD BOX
            SizedBox(height: 10 * fem),
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
              onPressed: () async {
                _tryValidation();
                try {
                  final newUser =
                      await _authentication.createUserWithEmailAndPassword(
                    email: userEmail,
                    password: userPassword,
                  ); // authentication은 비동기적으로 처리한다.

                  if (newUser.user != null && context.mounted) {
                    Navigator.pop(context);
                    showSnackBar(context, "회원가입에 성공했습니다", fem);
                    _firestore.collection(userEmail).doc('mediInfo').set({
                      "medicine": [],
                    });
                  }
                } catch (e) {
                  showSnackBar(context, "회원가입에 실패했습니다", fem);
                }
              },
              child: Text(
                'Sign up',
                textAlign: TextAlign.center,
                style: SafeGoogleFont(
                  'Nunito',
                  fontSize: 22 * fem,
                  fontWeight: FontWeight.w400,
                  height: 1.3625 * fem / fem,
                  color: const Color(0xffffffff),
                ),
              ),
            ), // SignUp Button
            signUpText("Login", context)
          ],
        ),
      ),
    );
  }
}

void showSnackBar(var context, String text, double fem) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: SafeGoogleFont(
          'Nunito',
          fontSize: 15 * fem,
          fontWeight: FontWeight.w400,
          height: 1.3625 * fem / fem,
          color: const Color(0xffffffff),
        ),
      ),
      backgroundColor: const Color(0xff8a60ff),
    ),
  );
}

Widget signUpText(var text, var context) {
  double baseWidth = 390;
  double fem = MediaQuery.of(context).size.width / baseWidth;
  double ffem = fem * 0.97;

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(
        onPressed: () => Navigator.pop(context),
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
    ],
  );
}

Widget inputBox(var context, var text, var icon) {
  double baseWidth = 390;
  double fem = MediaQuery.of(context).size.width / baseWidth;

  return Container(
    margin: EdgeInsets.only(top: 10 * fem),
    child: TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          size: 30 * fem,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff8a60ff), width: 1.0),
        ),
        border: const OutlineInputBorder(),
        hintText: text,
      ),
    ),
  );
}
