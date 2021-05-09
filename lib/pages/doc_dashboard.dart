import 'package:TeleDoc/src/middle_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import "package:flutter/cupertino.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:TeleDoc/pages/patient_dashboard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';


class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  CalendarController _controller = CalendarController();
  bool stateIndicator = false;
  ScrollController scroller = ScrollController();
  List<dynamic> Plist = [];
  var value;

  Widget listUI(String day) {
    return FutureBuilder(
        future: createDayPost(day),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: SpinKitRotatingCircle(
                  color: Colors.white,
                  size: 100.0,
                ),
              ),
            );
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: scroller,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return
                  // Padding(
                  //   padding: const EdgeInsets.all(5.0),
                  //   child:
                  Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(1, 10, 10, 10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    tileColor: Color.fromRGBO(255, 255, 255, 1),
                    leading: Text(
                      '${snapshot.data[index][6].toString().substring(0, 2)}:${snapshot.data[index][6].toString().substring(3, 5)}',
                      style: GoogleFonts.bebasNeue(textStyle:TextStyle(
                          color: Color.fromRGBO(75, 87, 132, 1),
                          //Color.fromRGBO(148, 113, 254, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 30)),
                    ),
                    trailing: (IconButton(
                      icon: Icon(Icons.menu),
                      iconSize: 40,
                      onPressed: () {},
                    )),
                    title: Text('patient ID : ${snapshot.data[index][1]}',
                        style: GoogleFonts.lato(textStyle:TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18))),
                    subtitle: Text('clinic ID : ${snapshot.data[index][2]}',
                        style: GoogleFonts.lato(textStyle:TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18))),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => nav_bar(),
                              //Patient_cards(),
                              settings: RouteSettings(
                                  arguments: [snapshot.data[index][1],snapshot.data[index][2]]),
                              fullscreenDialog: true))
                    },
                  ),
                ),
              );
              //);
            },
          );
        });
  }

  //post date to fetch apointments of that perticular date
  Future<List<dynamic>> createDayPost(String day) async {
    Map<String, dynamic> dataAtDate = {
      "Doctor_Id": 54372,
      "day_of_appointment": day.substring(0, 23),
    };
    print(day.substring(0, 23));
    final http.Response patientData = await http.post(
        'http://54.162.56.164:5000/appointment_info',
        body: jsonEncode(dataAtDate),
        headers: {"content-type": "application/json"});

    //if (patientData.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    //print(jsonDecode(patientData.body));

    var jsondata = json.decode(patientData.body);
    Plist.clear();
    setState(() {
      Plist = jsondata["result"];
    });
    print(Plist);
    return Plist;
    //} else if (patientData.statusCode == 200) {
    //   print('hii');
    // } else {
    //   // If the server did not return a 201 CREATED response,
    //   // then throw an exception.
    //   throw Exception('Failed to load patient list');
    // }
  }

  TextStyle dayStyle(FontWeight fontWeight) {
    return TextStyle(color: Color(0xff30384c), fontWeight: fontWeight);
  }

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            TableCalendar(
              startingDayOfWeek: StartingDayOfWeek.monday,
              initialCalendarFormat: CalendarFormat.week,
              calendarStyle: CalendarStyle(
                
                  weekdayStyle: dayStyle(FontWeight.normal),
                  weekendStyle: dayStyle(FontWeight.normal),
                  selectedColor: Color.fromRGBO(75, 87, 132, 1),
                  //selectedColor: Color.fromRGBO(148, 113, 254, 1),
                  todayColor: Colors.black38),
                  
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                      color: Color(0xff30384c),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  weekendStyle: TextStyle(
                      color: Color(0xff30384c),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  dowTextBuilder: (date, locale) {
                    return DateFormat.E(locale).format(date).substring(0, 1);
                  }),
              onDaySelected: (day, events, holyday) => {
                value = listUI(day.toString()),
              },
              onCalendarCreated: (first, last, format) =>
                  value = listUI(_controller.focusedDay.toString()),
              headerStyle: HeaderStyle(
                  formatButtonDecoration: BoxDecoration(
                    color: Color.fromRGBO(75, 87, 132, 1),
                    //color: Color.fromRGBO(148, 113, 254, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  formatButtonVisible: false,
                  centerHeaderTitle: true,
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  formatButtonShowsNext: false,
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Color(0xff30384c),
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Color(0xff30384c),
                  )),
              calendarController: _controller,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                          child: Container(
                  padding: EdgeInsets.only(left: 6, right: 6, top: 6),
                  width: MediaQuery.of(context).size.width * 1,
                  //height: MediaQuery.of(context).size.height * 1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular((25)),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(0)),
                      color: Color.fromRGBO(75, 87, 132, 1),
                      //color: Color.fromRGBO(148, 113, 254, 1)
                      ),
                  child: value
                  //Stack(
                  //   children: <Widget>[
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: <Widget>[
                  //         Padding(
                  //           padding: EdgeInsets.only(top: 50),
                  //           child: Text(
                  //             "Today",
                  //             style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 30,
                  //                 fontWeight: FontWeight.bold),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     Positioned(
                  //       bottom: 0,
                  //       height: 200,
                  //       width: MediaQuery.of(context).size.width,
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //             gradient: LinearGradient(
                  //                 begin: FractionalOffset.topCenter,
                  //                 end: FractionalOffset.bottomCenter,
                  //                 colors: [
                  //               Color.fromRGBO(148, 113, 254, 1).withOpacity(0),
                  //               Color.fromRGBO(148, 113, 254, 1)
                  //             ],
                  //                 stops: [
                  //               0.0,
                  //               1.0
                  //             ])),
                  //       ),
                  //     ),
                  //     Positioned(
                  //       bottom: 40,
                  //       right: 20,
                  //       child: Container(
                  //         padding: EdgeInsets.all((20)),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.all(Radius.circular(20)),
                  //             color: Color(0xffb038f1),
                  //             boxShadow: [
                  //               BoxShadow(color: Colors.black38, blurRadius: 10)
                  //             ]),
                  //         child: Text(
                  //           "+",
                  //           style: TextStyle(color: Colors.white, fontSize: 40),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  ),
            )
          ],
        ),
      ),
    );
  }
}
