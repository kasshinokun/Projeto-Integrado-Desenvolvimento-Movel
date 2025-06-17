//import 'dart:io';
//import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:rent_a_house/services/authservices.dart';
import 'package:flutter/material.dart';

//https://www.geeksforgeeks.org/flutter-store-user-details-using-firebase/
//Isolar depois---------------------------------------------------------------------------------------------------------------

class RealTimeDatabase extends StatefulWidget {
  const RealTimeDatabase({super.key});
  //title: 'Login Demonstração'
  @override
  State<RealTimeDatabase> createState() => _RealTimeDatabaseState();
}

class _RealTimeDatabaseState extends State<RealTimeDatabase> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final dlController = TextEditingController();
  final adController = TextEditingController();
  final phnController = TextEditingController();

  final firestore = FirebaseFirestore.instance;
  get data => null;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text('Insert Driver Details', style: TextStyle(fontSize: 28)),

                  SizedBox(height: 30),
                  SizedBox(height: 50),
                  TextFormField(
                    controller: nameController,
                    maxLength: 15,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: dlController,
                    maxLength: 20,
                    decoration: InputDecoration(
                      labelText: 'Driving Licencse Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: adController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: phnController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Phone No.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (nameController.text.isNotEmpty &&
                          ageController.text.isNotEmpty &&
                          dlController.text.isNotEmpty &&
                          adController.text.isNotEmpty &&
                          phnController.text.isNotEmpty) {
                        firestore.collection("Driver Details").add({
                          "Name": nameController.text,
                          "Age": ageController.text,
                          "Driving Licence": dlController.text,
                          "Address.": adController.text,
                          "Phone No.": phnController.text,
                        });
                      }
                    },
                    child: Text("Submit Details"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
