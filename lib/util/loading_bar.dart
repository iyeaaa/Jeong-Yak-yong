
import 'package:flutter/material.dart';
import 'package:medicine_app/util/utils.dart';

void showLoadingBar(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        content: Row(
          children: [
            const CircularProgressIndicator(color: Color(0xffa07eff)),
            const SizedBox(width: 15),
            Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text(
                "Loading...",
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showScaffold(String body, BuildContext context, double fem) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 800),
      content: Text(
        body,
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