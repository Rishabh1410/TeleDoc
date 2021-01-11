import 'package:TeleDoc/registration/login.dart';
import 'package:flutter/material.dart';
//import 'package:TeleDoc/registration/docotr_registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:TeleDoc/pages/doc_dashboard.dart';
import 'package:TeleDoc/pages/patient_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TeleDoc/local_data/data.dart';
import 'package:TeleDoc/registration/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //Id = getData('doc_Id');
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
            debugShowCheckedModeBanner: false,
            title: "teledoc",
            routes: {
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
                    del_data('doc_Id');
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
                    if ((await getData('doc_Id')) == null) {
                      Navigator.pushNamed(context, '/login');
                    } else {
                      print(await getData('doc_Id'));
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
