
import 'package:flutter/material.dart';

import '../util/utils.dart';

class MakingSchedulePage extends StatefulWidget {
  const MakingSchedulePage({Key? key}) : super(key: key);

  @override
  State<MakingSchedulePage> createState() => _MakingSchedulePageState();
}

class _MakingSchedulePageState extends State<MakingSchedulePage> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: true,
        title: Text(
          'Register Schedule',
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

    );
  }
}
