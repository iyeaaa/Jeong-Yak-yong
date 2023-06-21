import 'package:flutter/material.dart';
import 'package:medicine_app/util/loading_bar.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:reviews_slider/reviews_slider.dart';
import '../medicine_data/medicine.dart';
import '../util/collection.dart';
import '../util/event.dart';
import '../util/utils.dart';

class MakingSchedulePage extends StatefulWidget {
  final DateTime dateTime;
  final bool creating;
  final Event event;

  const MakingSchedulePage({
    Key? key,
    required this.dateTime,
    required this.creating,
    required this.event,
  }) : super(key: key);

  @override
  State<MakingSchedulePage> createState() => _MakingSchedulePageState();
}

class _MakingSchedulePageState extends State<MakingSchedulePage> {
  late DateTime selectDay = widget.dateTime;
  late TimeOfDay selectTime;

  late TextEditingController title;
  late TextEditingController note;
  int condition = 0;
  int hypertension = 100;
  int glucost = 80;
  bool conditionVisible = false;
  bool hypertensionVisible = false;
  bool glucoseVisible = false;
  bool noteVisible = false;

  @override
  void initState() {
    super.initState();

    if (!widget.creating) {
      conditionVisible = widget.event.conditionState;
      condition = widget.event.condition;
      hypertensionVisible = widget.event.hypertensionState;
      hypertension = widget.event.hypertension;
      glucoseVisible = widget.event.glucoseState;
      glucost = widget.event.glucose;
      noteVisible = widget.event.noteState;
      selectTime = TimeOfDay(
        hour: widget.dateTime.hour,
        minute: widget.dateTime.minute,
      );
      title = TextEditingController(text: widget.event.medicine.itemName);
      note = TextEditingController(text: widget.event.note);
    } else {
      final dt = DateTime.now().add(const Duration(minutes: 1));
      selectTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
      title = TextEditingController();
      note = TextEditingController();
    }

    debugPrint(selectDay.toString());
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 30 * fem),
            child: InkWell(
              onTap: () async {
                DateTime myDateTime = DateTime(
                  selectDay.year,
                  selectDay.month,
                  selectDay.day,
                  selectTime.hour,
                  selectTime.minute,
                );
                await Collections().memoAdd(Event(
                    medicine: Medicine.notExist(title.text),
                    dateTime: myDateTime,
                    conditionState: conditionVisible,
                    condition: condition,
                    noteState: noteVisible,
                    note: note.text,
                    hypertensionState: hypertensionVisible,
                    hypertension: hypertension,
                    glucoseState: glucoseVisible,
                    glucose: glucost));
                if (!widget.creating) {
                  await Collections().memoRmv(widget.event);
                }
                if (context.mounted) {
                  showScaffold(
                    '일정을 ${widget.creating ? "추가" : "수정"}했어요',
                    context,
                    fem,
                  );
                  Navigator.pop(context);
                }
              },
              child: Icon(
                widget.creating ? Icons.playlist_add : Icons.playlist_add_check,
                size: 33 * fem,
              ),
            ),
          ),
        ],
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
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20 * fem),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 15 * fem),
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
                    padding: EdgeInsets.fromLTRB(
                        20 * fem, 20 * fem, 20 * fem, 40 * fem),
                    child: TextField(
                      controller: title,
                      textAlign: TextAlign.start,
                      cursorColor: const Color(0xff6B35FF),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xffDFD3FF),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xff3600CA)),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff8559FF),
                          ),
                        ),
                        labelText: 'Schedule Title',
                        labelStyle: TextStyle(
                          color: const Color(0xff6B35FF),
                          fontSize: 18 * fem,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 100,
                      // <-- SEE HERE
                      minLines: 1, // <-- SEE HERE
                    ),
                  ),
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
                            initialValue: condition,
                            onChange: (int value) {
                              condition = value;
                              debugPrint("feel Value: $condition");
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
                            "메모",
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 17 * fem,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFA07EFF),
                            ),
                          ),
                          value: noteVisible,
                          onChanged: (value) {
                            setState(() {
                              noteVisible = !noteVisible;
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                20 * fem, 20 * fem, 20 * fem, 0),
                            child: TextField(
                              controller: note,
                              cursorColor: const Color(0xff6B35FF),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffDFD3FF),
                                labelStyle:
                                    const TextStyle(color: Color(0xff6B35FF)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xff3600CA)),
                                  borderRadius: BorderRadius.circular(5.5),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff8559FF),
                                  ),
                                ),
                                labelText: 'MEMO',
                                border: const OutlineInputBorder(),
                              ),
                              maxLines: 100,
                              // <-- SEE HERE
                              minLines: 1, // <-- SEE HERE
                            ),
                          ),
                          noteVisible,
                        )
                      ],
                    ),
                  ), // 메모
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
                                value: hypertension,
                                minValue: 50,
                                maxValue: 300,
                                onChanged: (value) => setState(
                                  () {
                                    hypertension = value;
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
                                value: glucost,
                                minValue: 50,
                                maxValue: 300,
                                onChanged: (value) => setState(
                                  () {
                                    glucost = value;
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
