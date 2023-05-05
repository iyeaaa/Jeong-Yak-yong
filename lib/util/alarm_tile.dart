import 'package:flutter/material.dart';
import 'package:medicine_app/util/medicine_card.dart';

class AlarmTile extends StatelessWidget {
  final String name;
  final String company;
  final String time;
  final void Function() onPressed;
  final void Function()? onDismissed;

  const AlarmTile({
    Key? key,
    required this.time,
    required this.onPressed,
    this.onDismissed,
    required this.name,
    required this.company,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Dismissible(
      // 슬라이드로 삭제할 수 있도록함
      key: key!,
      direction: onDismissed != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
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
        child: MedicineCard(
          fem: fem,
          name: name,
          company: company,
          ontap: () {},
          buttonName: time,
        ),
      ),
    );
  }
}
