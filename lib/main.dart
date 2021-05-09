import 'package:TeleDoc/registration/login.dart';
import 'package:TeleDoc/src/middle_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:TeleDoc/registration/docotr_registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:TeleDoc/pages/doc_dashboard.dart';
import 'package:TeleDoc/pages/patient_dashboard.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:TeleDoc/local_data/data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

SharedPreferences pref;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //SharedPreferences pref = await SharedPreferences.getInstance();
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['patient_id'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('channel', message.data['channel']);
      await pref.setString('token', message.data['Token']).then((value) => print('done.......................................'));
  print('Handling a background message ${message.messageId}');
  print(message.data);
}
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  pref = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var mssg;
  FirebaseMessaging _firebasemessaging = FirebaseMessaging.instance;

  

  Future<void> authentication(String token) async {
    Map post_data = {'User': '2', 'Doctor_Id': '9026', 'deviceToken': '$token'};
    http.Response check = await http.post('http://54.162.56.164:5000/signin',
        body: jsonEncode(post_data),
        headers: {"content-type": "application/json"});
    var auth_data = jsonDecode(check.body);
    print(auth_data[0][5].toString());

    //return auth_data[0][5].toString();
  }

  @override
  void initState() {
    super.initState();

    _firebasemessaging.getToken().then((token) {
      authentication(token).then((value) => print('hii')); // Print the Token in Console
    });
    //Id = getData('doc_Id');
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("1");

      await pref.setString("channel", message.data['channel']).then((value) => print('saved    1   .....................'));
      await pref.setString("token", message.data['Token']);

      flutterLocalNotificationsPlugin.show(
            message.data.hashCode,
            message.data['title'],
            message.data['patient_id'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
              ),
            ));

      // FlutterRingtonePlayer.play(
      //   android: AndroidSounds.notification,
      //   ios: IosSounds.bell,
      //   //looping: true,
      //   volume: 1.0,
      // );
      //print(message);
    });
  
     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async { print("2");

      // pref.setString("channel", "${mssg.substring(44, 49)}");
      // pref.setString("token", "${mssg.substring(58)}");

        Navigator.pushNamed(
            this.context,'/middle',
            //Patient_cards(),
            arguments: [message.data['patient_id'],message.data['clinic_id']]);
      });
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  //Future<dynamic> Id = getData('doc_Id');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
    // Check for errors
    if (snapshot.hasError) {
      print('{$snapshot.error}');
    }

    // Once complete, show your application
    if (snapshot.connectionState == ConnectionState.done) {
      return MaterialApp(
        title: "teledoc",
        routes: {
          '/middle':(context)=> nav_bar(),
          '/login': (context) => login_page(),
          //'/reg': (context) => DoctorReg(),
          '/dashboard': (context) => Timeline(),
          '/patients': (context) => Patient_cards(),
        },
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color.fromRGBO(148, 113, 254, 1)),
        home: MyHomePage(title: 'teledoc'),
      );
    }

    // Otherwise, show something whilst waiting for initialization to complete
    return (CircularProgressIndicator());
        },
      );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bg1.jpg'),
                      fit: BoxFit.cover))),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'continue as...',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 20,
                ),
                RawMaterialButton(
                  onPressed: () {
                    pref.remove('doc_Id');
                    //Navigator.pushNamed(context, '/dashboard');
                  },
                  elevation: 5.0,
                  fillColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 100.0,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                ),
                SizedBox(
                  height: 10,
                ),
                RawMaterialButton(
                  onPressed: () async {
                    if ((pref.getString('doc_Id')) == null) {
                      Navigator.pushNamed(context, '/login');
                    } else {
                      print(pref.getString('doc_Id'));
                      Navigator.pushNamed(context, '/dashboard');
                    }
                  },
                  elevation: 5.0,
                  fillColor: Colors.white,
                  child: Icon(
                    Icons.medical_services,
                    size: 100.0,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                ),
                SizedBox(
                  height: 10,
                ),
                RawMaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/patients');
                  },
                  elevation: 5.0,
                  fillColor: Colors.white,
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 100.0,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
