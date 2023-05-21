import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../util/utils.dart';

class InfoPage extends StatefulWidget {
  final String title;
  final String content;

  const InfoPage({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late String title;
  late String content;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    content = widget.content;
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
          title,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20 * fem, 20 * fem, 20 * fem, 20 * fem),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              20 * fem,
              20 * fem,
              20 * fem,
              20 * fem,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFA07EFF),
              borderRadius: BorderRadius.all(Radius.circular(20*fem)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFA07EFF),
                  spreadRadius: 0.5,
                  blurRadius: 10,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: AutoSizeText(
                content,
                maxLines: 18,
                overflow: TextOverflow.ellipsis,
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 16 * fem,
                  fontWeight: FontWeight.w500,
                  height: 2,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
