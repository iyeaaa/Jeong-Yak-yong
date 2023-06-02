import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/login/login_page.dart';
import 'package:medicine_app/util/loading_bar.dart';
import 'package:medicine_app/util/utils.dart';

import '../util/medicine_list.dart';

class SettingPage extends StatefulWidget {
  final Future<String> futureUserName;

  const SettingPage({
    Key? key,
    required this.futureUserName,
  }) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: SafeGoogleFont(
          'Poppins',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFA07EFF),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget continueButton = TextButton(
      child: Text(
        "Yes",
        style: SafeGoogleFont(
          'Poppins',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFA07EFF),
        ),
      ),
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
        showScaffold("Logout 됐어요", context, 1);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Logout",
        style: SafeGoogleFont(
          'Poppins',
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      content: Text(
        "정말 로그아웃 하시겠어요?",
        style: SafeGoogleFont(
          'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: true,
        title: Text(
          'Setting',
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 26 * fem,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          ),
        ),
        elevation: 0,
        toolbarHeight: 80 * fem,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: widget.futureUserName,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                  if (snapshot.hasData == false) {
                    return const Text("loading..");
                  }
                  //error가 발생하게 될 경우 반환하게 되는 부분
                  else if (snapshot.hasError) {
                    return const Text("ERROR");
                  }
                  // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                  else {
                    return Text(
                      "UserName: ${snapshot.data}",
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: const Color(0xff0a0146),
                      ),
                    );
                  }
                },
              ),
              Text(
                "userEmail: ${MediList.userEmail}",
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: const Color(0xff0a0146),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () => showAlertDialog(context),
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            borderRadius: BorderRadius.circular(28),
          ),
          child: Center(
            child: Icon(
              Icons.logout,
              color: const Color(0xff8a60ff),
              size: 35 * fem,
            ),
          ),
        ),
      ),
    );
  }
}
