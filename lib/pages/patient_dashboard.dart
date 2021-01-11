import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cupertino_icons/cupertino_icons.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:TeleDoc/src/pages/index.dart';

class Patient_cards extends StatefulWidget {
  Patient_cards({Key key}) : super(key: key);

  @override
  _Patient_cardsState createState() => _Patient_cardsState();
}

class _Patient_cardsState extends State<Patient_cards> {
  Map<String, dynamic> jsonvalue;

  Future<Map<String, dynamic>> cardvalue(var pat_Id) async {
    Map<String, dynamic> pat_id = {'id': 78};
    final http.Response patientValue = await http.post(
        'http://54.87.169.52:5000/get',
        body: jsonEncode(pat_id),
        headers: {"content-type": "application/json"});

    //if (patientData.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    //print(jsonDecode(patientData.body));
    setState(() {
      jsonvalue = jsonDecode(patientValue.body);
    });
    print(jsonvalue);

    return jsonvalue;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pat_Id = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: Container(
      //color: Colors.white,
      decoration: BoxDecoration(
          color: Colors.white,
          backgroundBlendMode: BlendMode.color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular((50)),
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50))),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 1,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            // patient data

            ListTile(
              leading: IconButton(
                icon: Icon(
                  Icons.video_call_sharp,
                  color: Colors.blueAccent,
                  size: 40,
                  semanticLabel: 'call',
                ),
                tooltip: 'video call your patient',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IndexPage(),
                          fullscreenDialog: true));
                },
              ),
              title: Text('data'),
              subtitle: Text('data'),
              trailing: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/default_image.png'),
              ),
              focusColor: Colors.transparent,
              hoverColor: Colors.white,
            ),

            SizedBox(
              height: 30,
            ),

            Card(
              color: Color.fromRGBO(245, 246, 250, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {},
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(70)),
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  'Patient Report',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),

//all the cards showing data

            FutureBuilder(
                future: cardvalue(pat_Id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: SpinKitRotatingCircle(
                          color: Colors.blueAccent,
                          size: 100.0,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              color: Color.fromRGBO(147, 112, 255, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {},
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      '${snapshot.data['Blood Pressure']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 150,
                                  height: 200,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              color: Color.fromRGBO(185, 126, 255, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {},
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      '${snapshot.data['Body Temp']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 150,
                                  height: 200,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              color: Color.fromRGBO(185, 226, 255, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {},
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      '${snapshot.data['Pulse']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 150,
                                  height: 200,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              color: Color.fromRGBO(75, 87, 132, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {},
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      '${snapshot.data['Body weight']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 150,
                                  height: 200,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              color: Color.fromRGBO(147, 112, 255, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {},
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      '${snapshot.data['Respiration Rate']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 150,
                                  height: 200,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              color: Color.fromRGBO(185, 126, 255, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {},
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      '${snapshot.data['Blood Glucose']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 150,
                                  height: 200,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    ));
    //Container(
    //     child: Column(
    //       children: [
    //         Container(
    //           //width: MediaQuery.of(context).size.width * 1,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.only(
    //                   topLeft: Radius.circular((50)),
    //                   topRight: Radius.circular(50),
    //                   bottomLeft: Radius.circular(50),
    //                   bottomRight: Radius.circular(50))),
    //           child: Column(
    //             children: [
    //               ListTile(
    //                 leading: IconButton(
    //                   icon: Icon(Icons.video_call),
    //                   tooltip: 'video call your patient',
    //                   onPressed: () {},
    //                 ),
    //                 title: Text('data'),
    //                 subtitle: Text('data'),
    //                 trailing: CircleAvatar(
    //                   backgroundImage:
    //                       AssetImage('assets/images/default_image.png'),
    //                 ),
    //                 focusColor: Colors.transparent,
    //                 hoverColor: Colors.white,
    //               ),
    //               Row(
    //                 children: [Card()],
    //               )
    //             ],
    //           ),
    //         )
    //       ],
    //     ),
    //   );
  }
}
