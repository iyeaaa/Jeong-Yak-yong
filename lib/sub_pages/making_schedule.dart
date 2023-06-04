import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:reviews_slider/reviews_slider.dart';

import '../util/utils.dart';

class MakingSchedulePage extends StatefulWidget {
  final DateTime dateTime;

  const MakingSchedulePage({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  @override
  State<MakingSchedulePage> createState() => _MakingSchedulePageState();
}

class _MakingSchedulePageState extends State<MakingSchedulePage> {
  late DateTime selectDay = widget.dateTime;
  late TimeOfDay selectTime;
  int feelValue = 0;
  int _currentValue = 100;
  bool conditionVisible = false;
  bool hypertensionVisible = false;
  bool glucoseVisible = false;
  bool memoVisible = false;

  @override
  void initState() {
    super.initState();
    final dt = DateTime.now().add(const Duration(minutes: 1));
    selectTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: selectTime,
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              // change the border color
              primary: Colors.red,
              // change the text color
              onSurface: Colors.purple,
            ),
            // button colors
            buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: Colors.green,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (res != null) setState(() => selectTime = res);
  } // 시계 보여주고 설정할 수 있게함

  Widget visibleWidget(Widget child, bool state) {
    return Visibility(
      visible: state,
      maintainAnimation: true,
      maintainState: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        opacity: state ? 1 : 0,
        child: child,
      ),
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
          "${selectDay.year}.${selectDay.month}.${selectDay.day}",
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20 * fem),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 15*fem),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: RawMaterialButton(
                      onPressed: pickTime,
                      fillColor: Colors.grey[50],
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: Text(
                          selectTime.format(context),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: const Color(0xFFA07EFF)),
                        ),
                      ),
                    ),
                  ), // Time pick Widget
                  Padding(
                    padding: EdgeInsets.only(bottom: 20 * fem),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CheckboxListTile(
                          title: Text(
                            "컨디션",
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 17 * fem,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFA07EFF),
                            ),
                          ),
                          value: conditionVisible,
                          onChanged: (value) {
                            setState(() {
                              conditionVisible = !conditionVisible;
                            });
                          },
                          secondary: Icon(
                            Icons.face,
                            size: 22 * fem,
                            color: const Color(0xFFA07EFF),
                          ),
                          fillColor: const MaterialStatePropertyAll(
                            Color(0xFFA07EFF),
                          ),
                        ),
                        visibleWidget(
                          ReviewSlider(
                            onChange: (int value) {
                              feelValue = value;
                              debugPrint("feel Value: $feelValue");
                            },
                            optionStyle: SafeGoogleFont(
                              'Poppins',
                              fontSize: 10 * fem,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFA07EFF),
                            ),
                          ),
                          conditionVisible,
                        ),
                      ],
                    ),
                  ), // Feel pick Widget
                  Padding(
                    padding: EdgeInsets.only(bottom: 20 * fem),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CheckboxListTile(
                          title: Text(
                            "혈압",
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 17 * fem,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFA07EFF),
                            ),
                          ),
                          value: hypertensionVisible,
                          onChanged: (value) {
                            setState(() {
                              hypertensionVisible = !hypertensionVisible;
                            });
                          },
                          secondary: Icon(
                            Icons.bloodtype_rounded,
                            size: 22 * fem,
                            color: const Color(0xFFA07EFF),
                          ),
                          fillColor: const MaterialStatePropertyAll(
                            Color(0xFFA07EFF),
                          ),
                        ),
                        visibleWidget(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // https://pub.dev/packages/numberpicker
                              NumberPicker(
                                axis: Axis.horizontal,
                                value: _currentValue,
                                minValue: 50,
                                maxValue: 300,
                                onChanged: (value) => setState(
                                  () {
                                    _currentValue = value;
                                    debugPrint("혈압: $value");
                                  },
                                ),
                                textStyle: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 15 * fem,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[600],
                                ),
                                selectedTextStyle: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 20 * fem,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFA07EFF),
                                ),
                              ),
                            ],
                          ),
                          hypertensionVisible,
                        ),
                      ],
                    ),
                  ), // 혈압수치 기록
                  Padding(
                    padding: EdgeInsets.only(bottom: 20 * fem),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CheckboxListTile(
                          title: Text(
                            "당 수치",
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 17 * fem,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFA07EFF),
                            ),
                          ),
                          value: glucoseVisible,
                          onChanged: (value) {
                            setState(() {
                              glucoseVisible = !glucoseVisible;
                            });
                          },
                          secondary: Icon(
                            Icons.add_circle_outline,
                            size: 22 * fem,
                            color: const Color(0xFFA07EFF),
                          ),
                          fillColor: const MaterialStatePropertyAll(
                            Color(0xFFA07EFF),
                          ),
                        ),
                        visibleWidget(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // https://pub.dev/packages/numberpicker
                              NumberPicker(
                                axis: Axis.horizontal,
                                value: _currentValue,
                                minValue: 50,
                                maxValue: 300,
                                onChanged: (value) => setState(
                                  () {
                                    _currentValue = value;
                                    debugPrint("당 수치: $value");
                                  },
                                ),
                                textStyle: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 15 * fem,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[600],
                                ),
                                selectedTextStyle: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 20 * fem,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFA07EFF),
                                ),
                              ),
                            ],
                          ),
                          glucoseVisible,
                        ),
                      ],
                    ),
                  ), // 당수치 기록
                  Padding(
                    padding: EdgeInsets.only(bottom: 20 * fem),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CheckboxListTile(
                          title: Text(
                            "메모",
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 17 * fem,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFA07EFF),
                            ),
                          ),
                          value: memoVisible,
                          onChanged: (value) {
                            setState(() {
                              memoVisible = !memoVisible;
                            });
                          },
                          secondary: Icon(
                            Icons.note_alt_outlined,
                            size: 22 * fem,
                            color: const Color(0xFFA07EFF),
                          ),
                          fillColor: const MaterialStatePropertyAll(
                            Color(0xFFA07EFF),
                          ),
                        ),
                        visibleWidget(
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [],
                          ),
                          memoVisible,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}