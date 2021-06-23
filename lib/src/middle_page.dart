import 'package:flutter/material.dart';
import 'package:TeleDoc/main.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:TeleDoc/src/pages/call.dart';
import 'package:TeleDoc/pages/patient_dashboard.dart';

class nav_bar extends StatefulWidget {
  nav_bar({Key key}) : super(key: key);

  @override
  _nav_barState createState() => _nav_barState();
}

class _nav_barState extends State<nav_bar> {


  final _channelController = TextEditingController();
  PageController page_changer = PageController();
  String channel;
  String token;

  /// if channel textField is validated to have error
  bool _validateError = false;
  int currentIndex = 0;

  //made stream controller to get a stream of data
  //StreamController _flow = StreamController();
  fetch_data() {
    fetch_data() async{
    // await pref.setString('channel', 'temp');
    // await pref.setString('token', '00648977aeb5abe4b09b4ffcb004f36cda5IACaOvCnHSESY/SSOmkcej42jdkuxRFdLQuKSt2t6KiiXMqFUwsAAAAAEADBVZQ5qWZ1YAEAAQCpZnVg');
    channel = pref.getString('channel');
    token = pref.getString('token');
    print(channel);
    print(token);
  }
    channel = pref.getString('channel');
    token = pref.getString('token');
    print(channel);
    print(token);
  }



  @override
  void initState() {
    super.initState();
    fetch_data();
    onJoin(channel, token).then((value) => print("permission granting"));
  }

  @override
  void dispose() {
    //TODO: implement dispose
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    List pat_Id = ModalRoute.of(context).settings.arguments;
    List<Widget> pages = [Patient_cards(pat_Id: pat_Id,),CallPage(channelName: channel, role: ClientRole.Broadcaster, token: token)];
    
    return MaterialApp(
        home: Scaffold(
        body: PageView(
        children: pages,
        controller: page_changer,
        onPageChanged: (int index){
          setState(() {
            currentIndex = index;
          });
        },
        ),
        bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            page_changer.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Data',
            icon: new Icon(Icons.data_usage),
          ),
          BottomNavigationBarItem(
            icon: new Icon(AntDesign.videocamera),
            label: 'video',
          ),
        ],
      ),
          )

    );
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
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => CallPage(
      //         channelName: channel, role: ClientRole.Broadcaster, token: token),
      //   ),
      // );
    } else {
      print("cant connect video call");
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}

