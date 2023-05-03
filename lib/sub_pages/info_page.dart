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
        centerTitle: false,
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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_sharp),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(
            8 * fem,
            20 * fem,
            8 * fem,
            20 * fem,
          ),
          child: Stack(
            children: [
              Image.asset('image/group-842.png'),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      16 * fem,
                      20 * fem,
                      16 * fem,
                      20 * fem,
                    ),
                    child: Text(
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
            ],
          ),
        ),
      ),
    );
  }
}
