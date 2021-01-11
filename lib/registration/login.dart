import 'dart:convert';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:TeleDoc/local_data/data.dart';
import 'package:TeleDoc/pages/doc_dashboard.dart';
import 'package:TeleDoc/registration/docotr_registration.dart';

class login_page extends StatefulWidget {
  login_page({Key key}) : super(key: key);

  @override
  _login_pageState createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  TextEditingController doc_Id = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future<String> authentication(String doc_Id) async {
    Map post_data = {'User': '2', 'Doctor_Id': '$doc_Id'};
    http.Response check = await http.post('http://54.87.169.52:5000/signin',
        body: jsonEncode(post_data),
        headers: {"content-type": "application/json"});
    var auth_data = jsonDecode(check.body);
    print(auth_data[0][5].toString());

    return auth_data[0][5].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Form(
            child: ListView(
              children: [
                TextFormField(
                  controller: doc_Id,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      labelText: "enter your doctor Id"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: pass,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      labelText: "enter your password"),
                ),
                // FutureBuilder(
                //   future: authentication(doc_Id.text),
                //   builder: (BuildContext context, AsyncSnapshot snapshot) =>
                RaisedButton(
                    onPressed: () {
                      //init('doc_Id', '${doc_Id.text}');
                      Future<String> auth = authentication(doc_Id.text);
                      auth.then((value) {
                        if (value == pass.text) {
                          print('1');
                          init('doc_Id', doc_Id.text);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Timeline(),
                                  fullscreenDialog: true));
                        } else if (value == null) {
                          print('2');
                          AlertDialog(
                            title: Text('sorry you have no '),
                          );
                        } else {
                          print('3');
                          AlertDialog(
                            title: Text(
                              'wrong Id or Password',
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }
                      });
                    },
                    child: Center(
                        child: Text(
                      'Login',
                      style: TextStyle(fontSize: 20),
                    ))),
                //),
                GestureDetector(
                    child: Text(
                      'new user? register',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorReg(),
                              fullscreenDialog: true));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
