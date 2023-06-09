import 'dart:math';
import 'package:flutter/material.dart';
import 'package:medicine_app/medicine_data/medicine_cnt_management.dart';
import 'package:medicine_app/sub_pages/caution_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:medicine_app/util/medicine_card.dart';
import '../medicine_data/medicine.dart';
import '../util/collection.dart';
import '../util/utils.dart';

class MedicineSettingPage extends StatefulWidget {
  final Medicine medicine;
  final bool creating;

  const MedicineSettingPage({
    Key? key,
    required this.medicine,
    required this.creating,
  }) : super(key: key);

  @override
  State<MedicineSettingPage> createState() => _MedicineSettingPageState();
}

class _MedicineSettingPageState extends State<MedicineSettingPage> {
  late Medicine medicine;
  Collections mediList = Collections();
  int mediCount = 0;

  @override
  void initState() {
    super.initState();
    medicine = widget.medicine;
    mediCount = medicine.count;
  }

  void showAddOrChangeMessage(double fem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${medicine.itemName}을 ${widget.creating ? "추가" : "변경"}했어요.",
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

  Widget profile(double fem) {
    void showCustomDialog(BuildContext context) {
      showGeneralDialog(
        context: context,
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) {
          return Center(
            child: SizedBox(width: 300 * fem, child: loadImageExample()),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: child,
          );
        },
      );
    }

    return Container(
      height: 95 * fem,
      padding: EdgeInsets.only(top: 10 * fem),
      child: MedicineCard(
        fem: fem,
        name: medicine.itemName,
        company: medicine.entpName,
        ontap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CautionPage(
              medicine: medicine,
            ),
          ),
        ),
        imageOntap: () {
          if (medicine.imageUrl == "No Image") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 800),
                content: Text(
                  "이미지가 없어요",
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
          } else {
            showCustomDialog(context);
          }
        },
        buttonName: "주의사항",
        isChecked: false,
        iconData: medicine.imageUrl == "No Image"
            ? Icons.image_not_supported_sharp
            : Icons.image,
      ),
    );
  }

  Widget loadImageExample() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurpleAccent, width: 2),
      ),
      child: Image.network(
        medicine.imageUrl,
        width: 400,
      ),
    );
  }

  Widget mediInfoCard(int index, double fem) {
    var titleList = ["다음과 같은 효능이 있어요", "다음과 같이 사용해야 해요"];
    var contentList = [medicine.effect, medicine.useMethod];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20 * fem,
        20 * fem,
        20 * fem,
        20 * fem,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFA07EFF),
        borderRadius: BorderRadius.all(Radius.circular(20 * fem)),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFA07EFF),
            spreadRadius: 0.5,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleList[index],
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 16 * fem,
              fontWeight: FontWeight.w900,
              height: 2,
              color: const Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(height: 10),
          AutoSizeText(
            contentList[index],
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
        ],
      ),
    );
  }

  Widget settingCount(double fem) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "먹을 약 개수 : ",
            overflow: TextOverflow.ellipsis,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 20 * fem,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: const Color(0xffa98aff),
            ),
          ),
          Container(
            width: 120 * fem,
            height: 50 * fem,
            padding: EdgeInsets.fromLTRB(12 * fem, 0, 12 * fem, 0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurple),
              borderRadius: BorderRadius.all(Radius.circular(10 * fem)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => setState(() {
                    mediCount = max(0, mediCount - 1);
                  }),
                  child: Text(
                    "-",
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 20 * fem,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                ),
                Text(
                  mediCount.toString(),
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 22 * fem,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                InkWell(
                  onTap: () => setState(() {
                    mediCount = max(0, mediCount + 1);
                  }),
                  child: Text(
                    "+",
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 20 * fem,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: true,
        actions: [
          if (medicine.entpName.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: 30 * fem),
              child: IconButton(
                onPressed: () async {
                  widget.creating
                      ? await mediList.medicineAdd(medicine, mediCount)
                      : await mediList.medicineRmv(medicine);
                  if (!widget.creating) {
                    await mediList.medicineAdd(medicine, mediCount);
                  }
                  showAddOrChangeMessage(fem);
                  rmvEventsWithoutMemo();
                  updateEvents(await mediList.getMediList());
                },
                icon: Icon(
                  widget.creating ? Icons.playlist_add : Icons.save_outlined,
                  size: 35 * fem,
                ),
              ),
            ),
        ],
        elevation: 0,
        toolbarHeight: 80 * fem,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_sharp),
        ),
        automaticallyImplyLeading: false,
        title: AutoSizeText(
          medicine.itemName,
          textAlign: TextAlign.start,
          maxLines: 2,
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 20 * fem,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(
              30 * fem,
              20 * fem,
              30 * fem,
              20 * fem,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                profile(fem),
                SizedBox(height: 30 * fem),
                mediInfoCard(0, fem),
                SizedBox(height: 30 * fem),
                mediInfoCard(1, fem),
                SizedBox(height: 30 * fem),
                if (medicine.entpName.isNotEmpty) settingCount(fem),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SlimyCard(
// color: Colors.transparent,
// width: 400,
// topCardHeight: 200,
// bottomCardHeight: 200,
// borderRadius: 15,
// topCardWidget: profile(fem),
// bottomCardWidget: loadImageExample(),
// slimeEnabled: true,
// ),

class DayWidget extends StatefulWidget {
  final String day;
  final double fem;

  const DayWidget({super.key, required this.fem, required this.day});

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  bool isSelected = false;
  late String day;
  late double fem;

  @override
  void initState() {
    super.initState();
    day = widget.day;
    fem = widget.fem;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        width: 40 * widget.fem,
        height: 50 * widget.fem,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffa07eff) : const Color(0xffDFD3FF),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            widget.day,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 16 * widget.fem,
              fontWeight: FontWeight.w500,
              height: 1.5 * widget.fem,
              color: const Color(0xffffffff),
            ),
          ),
        ),
      ),
    );
  }
}

// if (!widget.creating)
//   Expanded(
//     child: Center(
//       child: alarms.isNotEmpty
//           ? ListView.separated(
//               itemCount: alarms.length,
//               padding: EdgeInsets.only(top: 5 * fem),
//               separatorBuilder: (context, index) =>
//                   const Divider(),
//               itemBuilder: (context, index) {
//                 return AlarmTile(
//                   key: Key(alarms[index].id.toString()),
//                   time: TimeOfDay(
//                     hour: alarms[index].dateTime.hour,
//                     minute: alarms[index].dateTime.minute,
//                   ).format(context),
//                   onPressed: () =>
//                       navigateToAlarmScreen(alarms[index]),
//                   // edit 페이지로 이동하는 함수 호출
//                   onDismissed: () {
//                     Alarm.stop(alarms[index].id)
//                         .then((_) => loadAlarms());
//                   },
//                   name: medicine.itemName,
//                   company: medicine.entpName,
//                 ); // 알람 타일,
//               },
//             )
//           : Text(
//               "No alarms set",
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//     ),
//   ), // 알람 리스트
