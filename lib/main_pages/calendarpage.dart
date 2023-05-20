import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import '../model/event.dart';

class WeekViewDemo extends StatefulWidget {
  const WeekViewDemo({Key? key}) : super(key: key);

  @override
  WeekViewDemoState createState() => WeekViewDemoState();
}

class WeekViewDemoState extends State<WeekViewDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: WeekView<Event>(
        onDateTap: (date) => debugPrint(date.toString()),
        headerStyle: const HeaderStyle(
          headerTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFA07EFF),
          )
        ),
      ),
    );
  }

  // Future<void> _addEvent() async {
  //   final event = await context.pushRoute<CalendarEventData<Event>>(
  //     CreateEventPage(
  //       withDuration: true,
  //     ),
  //   );
  //   if (event == null) return;
  //   CalendarControllerProvider.of<Event>(context).controller.add(event);
  // }
}
