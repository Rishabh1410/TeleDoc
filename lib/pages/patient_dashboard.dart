import 'dart:async';
//import 'package:TeleDoc/local_data/data.dart';
import 'package:TeleDoc/main.dart';
import 'package:TeleDoc/src/pages/call.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class Patient_cards extends StatefulWidget {
  Patient_cards({Key key}) : super(key: key);

  @override
  _Patient_cardsState createState() => _Patient_cardsState();
}

class _Patient_cardsState extends State<Patient_cards> {
  final _channelController = TextEditingController();
  String channel;
  String token;

  /// if channel textField is validated to have error
  bool _validateError = false;
  Map<String, dynamic> jsonvalue;

  //made stream controller to get a stream of data
  //StreamController _flow = StreamController();
  fetch_data() {
    channel = pref.getString('channel');
    token = pref.getString('token');
    print(channel);
    print(token);
  }

  Future<Map<String, dynamic>> cardvalue(var pat_Id) async {
    Map<String, dynamic> pat_id = {'id': 78};
    final http.Response patientValue = await http.post(
        'http://54.165.225.128:5000/get',
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

  // Future<void> getId() async {
  //   var classId = FirebaseFirestore.instance;
  //   var value = await classId.doc('user').snapshots().first;
  //   print("class Id is $value");
  // }

  @override
  void initState() {
    super.initState();
    fetch_data();
  }

  @override
  void dispose() {
    //TODO: implement dispose
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
                onPressed: () async {
                  //await getId();
                  onJoin(channel, token);
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
              color: Colors.blueAccent,
              //Color.fromRGBO(245, 246, 250, 1),
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
                //StreamBuilder(
                future: cardvalue(pat_Id),
                //stream:
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
                              color: Colors.blueAccent,
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
                              color: Colors.blueAccent,
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
                              color: Colors.blueAccent,
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
                              color: Colors.blueAccent,
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
                              color: Colors.blueAccent,
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
                              color: Colors.blueAccent,
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

  Future<void> onJoin(String channel, String token) async {
    print(channel);
    print(token);
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (channel != null) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
              channelName: channel, role: ClientRole.Broadcaster, token: token),
        ),
      );
    } else {
      print("cant connect video call");
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
