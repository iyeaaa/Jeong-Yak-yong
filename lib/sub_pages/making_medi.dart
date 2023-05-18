import 'package:flutter/material.dart';

import '../util/utils.dart';

class MakingMediPage extends StatefulWidget {
  const MakingMediPage({Key? key}) : super(key: key);

  @override
  State<MakingMediPage> createState() => _MakingMediPageState();
}

class _MakingMediPageState extends State<MakingMediPage> {

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: true,
        title: Text(
          "약 생성",
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 23 * fem,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          ),
        ),
        elevation: 0,
        toolbarHeight: 80 * fem,
      ),
    );
  }
}
