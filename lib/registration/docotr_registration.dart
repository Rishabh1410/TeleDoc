import 'dart:io';

import 'package:TeleDoc/registration/login.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class DoctorReg extends StatefulWidget {
  DoctorReg({Key key}) : super(key: key);

  @override
  _DoctorRegState createState() => _DoctorRegState();
}

class _DoctorRegState extends State<DoctorReg> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  File _imageFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController age_controller,
      name_controller,
      email_controller,
      city_controller,
      state_controller,
      country_controller,
      pincode_controller,
      phone_num_controller,
      password_controller,
      doc_id_controller,
      user_controller;
  void initState() {
    super.initState();
    doc_id_controller = TextEditingController();
    user_controller = TextEditingController();
    age_controller = TextEditingController();
    email_controller = TextEditingController();
    name_controller = TextEditingController();
    city_controller = TextEditingController();
    state_controller = TextEditingController();
    country_controller = TextEditingController();
    pincode_controller = TextEditingController();
    phone_num_controller = TextEditingController();
    password_controller = TextEditingController();
  }

  void dispose() {
    age_controller.dispose();
    name_controller.dispose();
    email_controller.dispose();
    city_controller.dispose();
    state_controller.dispose();
    country_controller.dispose();
    pincode_controller.dispose();
    phone_num_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  Map create_map() {
    Map<String, dynamic> data = {
      'User': user_controller.text,
      'Doctor_Id': doc_id_controller.text,
      'name': name_controller.text,
      'Age': age_controller.text,
      'email': email_controller.text,
      'phone': phone_num_controller.text,
      'pass': password_controller.text,
      'city': city_controller.text,
      'state': state_controller.text,
      'country': country_controller.text,
      'PIN': pincode_controller.text
    };
    return data;
  }

  Future<void> create_post(Map<String, dynamic> data) async {
    final http.Response response = await http.post(
        'http://54.87.169.52:5000/signup',
        body: jsonEncode(data),
        headers: {"content-type": "application/json"});

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to upload data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(148, 113, 254, 1),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Form(
              autovalidateMode: AutovalidateMode.always,
              //autovalidate: true,   //because it was depricated
              key: formkey,
              child: ListView(
                children: <Widget>[
                  CircleAvatar(
                      radius: 60,
                      backgroundImage: _imageFile == null
                          ? AssetImage("assets/Image/default_image.png")
                          : FileImage(File(_imageFile.path))),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    FlatButton.icon(
                      icon: Icon(Icons.camera),
                      label: Text("Camera"),
                      onPressed: () {
                        TakeImage(ImageSource.camera);
                      },
                    ),
                    FlatButton.icon(
                      icon: Icon(Icons.image),
                      label: Text("Gallery"),
                      onPressed: () {
                        TakeImage(ImageSource.gallery);
                      },
                    )
                  ]),
                  TextFormField(
                    controller: user_controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: "user"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: doc_id_controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: "doctor ID"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: name_controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: "name"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: age_controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: "age"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: city_controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: "city"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: state_controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: "state"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: country_controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: "country"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: pincode_controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: "pincode"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: email_controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      labelText: "email",
                    ),
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'email required'),
                      EmailValidator(errorText: 'Not a Valid Email'),
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: phone_num_controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: "phone no."),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: password_controller,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        labelText: "generate password"),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  RaisedButton(
                    child: Text(
                      'Register',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)),
                    color: Color.fromRGBO(148, 113, 254, 1),
                    onPressed: () {
                      Map json = create_map();
                      create_post(json).then((value) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => login_page(),
                                  fullscreenDialog: true)));
                    },
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              )),
        ),
      ),
    );
  }

  Future TakeImage(ImageSource source) async {
    final PickedFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = File(PickedFile.path);
    });
  }
}
