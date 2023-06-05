import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/util/utils.dart';

class AlarmTile extends StatelessWidget {
  final String title;
  final String content;
  final void Function() onPressed;
  final void Function()? onDismissed;
  final GestureTapCallback ontap;

  const AlarmTile({
    Key? key,
    required this.onPressed,
    this.onDismissed,
    required this.title,
    required this.content,
    required this.ontap,
  }) : super(key: key);

  Widget alarmTile(String title, String content, double fem) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: 200 * fem,
        height: 300 * fem,
        padding: EdgeInsets.all(10 * fem),
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(23 * fem),
          border: Border.all(color: const Color(0xffa07eff)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Container(
                    width: 68 * fem,
                    height: 68 * fem,
                    decoration: BoxDecoration(
                      color: const Color(0xffa07eff),
                      borderRadius: BorderRadius.circular(20 * fem),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.alarm,
                        size: 40 * fem,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Text(
                  title,
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 26 * fem,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 0.01 * fem,
                ),
              ],
            ),
            SizedBox(height: 20 * fem),
            AutoSizeText(
              content,
              style: SafeGoogleFont(
                'Poppins',
                // fontSize: 17 * fem,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Dismissible(
      // 슬라이드로 삭제할 수 있도록함
      key: key!,
      direction: DismissDirection.vertical,
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20 * fem),
          color: const Color(0xffa07eff),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        child: const Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDismissed?.call(),
      child: RawMaterialButton(
        onPressed: onPressed,
        child: alarmTile(title, content, fem),
      ),
    );
  }
}
