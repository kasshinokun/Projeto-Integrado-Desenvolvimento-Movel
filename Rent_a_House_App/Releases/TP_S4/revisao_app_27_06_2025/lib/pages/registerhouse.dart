//--->>https://www.coderzheaven.com/2019/10/17/googles-flutter-tutorial-save-image-as-string-in-sqlite-database/

import 'dart:typed_data';
import 'package:rent_a_house/pages/model/utility.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'utility.dart';
import 'dbdao/dbhelper.dart';
import 'dart:async';

void main() {
  runApp(MyNotesApp());
}

class MyNotesApp extends StatelessWidget {
  const MyNotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RegisterHousePage(),
    );
  }
}

class RegisterHousePage extends StatefulWidget {
  //
  const RegisterHousePage({super.key});

  final String title = "Registro de Imóveis";
  @override
  State<RegisterHousePage> createState() => _RegisterHousePageState();
}

class _RegisterHousePageState extends State<RegisterHousePage> {
  //
  final ImagePicker _picker = ImagePicker();
  late int idHouse;
  late Future<File> imageFile;
  late Image image;
  late DBHelper dbHelper;
  late List<Photo> images;

  @override
  void initState() {
    super.initState();
    images = [];
    dbHelper = DBHelper.instance;
    refreshImages();
  }

  refreshImages() {
    dbHelper.getPhotos().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  pickImageFromGallery() async {
    try {
      await _picker.pickImage(source: ImageSource.gallery).then((imgFile) {
        String imgString = Utility.base64String(
          imgFile?.readAsBytes() as Uint8List,
        );
        Photo photo = Photo(id: 1, photoName: imgString, idHouse: 1);
        dbHelper.insertPhoto(photo);
        refreshImages();
      });
    } catch (e) {
      setState(() {
        e;
      });
    }
  }

  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children:
            images.map((photo) {
              return Utility.imageFromBase64String(photo.photoName);
            }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          TextButton.icon(
            label: Text("Menu", style: TextStyle(fontSize: 20)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/auth');
              Navigator.popAndPushNamed(context, '/auth');
            },
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        onPressed: () {},
        child: const Icon(
          Icons.library_add_sharp,
          color: Colors.white,
          size: 25,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ColoredBox(
                  color: Colors.grey,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: Flexible(child: gridView()),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.image_search),
                  label: Text(
                    "Adicionar Imagens",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    pickImageFromGallery();
                  },
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
                  children: [
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'CEP',
                        labelStyle: TextStyle(fontSize: 20),
                        hintText:
                            MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 'CEP por favor'
                                : 'Caro(a) Cliente, entre com o CEP por favor',
                        hintStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: Icon(Icons.location_city),
                      ),
                      keyboardType: TextInputType.number,
                    ), //TextFormField CEP
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Logradouro/Rua',
                        labelStyle: TextStyle(fontSize: 20),
                        hintText:
                            MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 'Rua por favor'
                                : 'Caro(a) Cliente, entre com Logradouro/Rua por favor',
                        hintStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: Icon(Icons.home),
                      ),
                      keyboardType: TextInputType.text,
                    ), //TextFormField Logradouro/Rua
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Número',
                        labelStyle: TextStyle(fontSize: 20),
                        hintText:
                            MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 'Número por favor'
                                : 'Caro(a) Cliente, entre com o Número por favor',
                        hintStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: Icon(Icons.note_rounded),
                      ),
                      keyboardType: TextInputType.number,
                    ), //TextFormField Numero
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Complemento',
                        labelStyle: TextStyle(fontSize: 20),
                        hintText:
                            MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 'Complemento por favor'
                                : 'Caro(a) Cliente, entre com o Complemento por favor',
                        hintStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: Icon(Icons.add),
                      ),
                      keyboardType: TextInputType.text,
                    ), //TextFormField Complemento
                    TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Valor',
                        labelStyle: TextStyle(fontSize: 20),
                        hintText:
                            MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 'Valor por favor'
                                : 'Caro(a) Cliente, entre com o Valor por favor',
                        hintStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: Icon(Icons.note_rounded),
                      ),
                      keyboardType: TextInputType.number,
                    ), //TextFormField Valor
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Descrição", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    TextFormField(
                      //textAlign: TextAlign.center,
                      maxLines: 10,

                      decoration: InputDecoration(
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        //labelText: 'Descrição',
                        //labelStyle: TextStyle(fontSize: 20),
                        hintText:
                            MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 'Descrição por favor'
                                : 'Caro(a) Cliente, entre com o Descrição por favor',
                        hintStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        //suffixIcon: Icon(Icons.add),
                      ),
                      keyboardType: TextInputType.text,
                    ), //TextFormField Descrição
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
