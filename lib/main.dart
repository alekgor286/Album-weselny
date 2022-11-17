import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() {
  runApp(new MaterialApp(
    title: "Album weselny",
    home: LandingScreen(),
  ));
}

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  File? imageFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openFile();
    });
  }
  _saveFile(File file) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String fileName = basename(file.path);
    String filePath = '$appDocPath/$fileName';
    await file.copy(filePath);
  }
  _openFile() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    var fileSystemEntity = appDocDir.listSync();
    fileSystemEntity.removeWhere((element) => !basename(element.path).contains(".jpg"));
    if (fileSystemEntity.isNotEmpty) {
      setState(() {
        imageFile = File(fileSystemEntity.first.path);
      });
    }
  }
  _openGallery(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(picture!.path);
    });
    _saveFile(imageFile!);
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = File(picture!.path);
    });
    _saveFile(imageFile!);
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext cotext) {
          return AlertDialog(
            title: Text("Dokonaj wyboru"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Aparat"),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _decideImageView() {
    if (imageFile == null) {
      return Text("Nie wybrano zdjecia!");
    } else {
      return Image.file(imageFile!, width: 400, height: 400);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album weselny'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.local_print_shop_outlined),
            tooltip: 'Drukuj',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.photo_camera_outlined),
            tooltip: 'Zrób zdjęcie',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.image),
            tooltip: 'Wybierz zdjęcie z galerii',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'Udostępnij',
          ),
        ],
        backgroundColor: Colors.teal,
      ),

      body: Container(

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _decideImageView(),
              ElevatedButton (
                onPressed: () {
                  _showChoiceDialog(context);
                },
                child: Text("Wybierz zdjecie"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                )
              ),
            ],
          ),
        )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy_rounded),
            label: 'Skopiuj',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_format),
            label: 'Tekst',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Upiększ',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_filter ),
            label: 'Filtry',
            backgroundColor: Colors.teal,
          ),
        ],
        selectedItemColor: Colors.black,
      ),
    );
  }

}

