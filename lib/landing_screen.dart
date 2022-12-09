import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'details_screen.dart';
import 'main.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final List<List<PhotoItem>> _items = [[]];
  ScrollController? _scrollController;
  var currentPage = 1;
  var allPages = 1;

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
    setState(() {
      _items[currentPage-1] = [];
    });
    Directory appDocDir = await getApplicationDocumentsDirectory();
    var fileSystemEntity = appDocDir.listSync();
    log('data: $fileSystemEntity');
    fileSystemEntity
        .removeWhere((element) => !basename(element.path).contains(".jpg"));

    for (var element in fileSystemEntity) {
      setState(() {
        _items[currentPage-1].add(PhotoItem(File(element.path)));
      });
    }
  }

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    var file = File(picture!.path);
    setState(() {
      _items[currentPage-1].add(PhotoItem(file));
    });
    _saveFile(file);
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    var file = File(picture!.path);
    setState(() {
      _items[currentPage-1].add(PhotoItem(file));
    });
    _saveFile(file);
    Navigator.of(context).pop();
  }

  void _increment() {
    setState(() => allPages++);
    _items.add([]);
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
    if (_items[currentPage-1].isEmpty) {
      return Text("Nie wybrano zdjecia!");
    } else {
      return DragAndDropGridView(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 25,
            mainAxisSpacing: 25,
            crossAxisCount: 3,
          ),
          padding: const EdgeInsets.all(20),
          itemCount: _items[currentPage-1].length,
          onWillAccept: (oldIndex, newIndex) {
            return true;
          },
          onReorder: (oldIndex, newIndex) {
            final temp = _items[currentPage-1][oldIndex];
            _items[currentPage-1][oldIndex] = _items[currentPage-1][newIndex];
            _items[currentPage-1][newIndex] = temp;

            setState(() {});
          },
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      image: _items[currentPage-1][index].image,
                    ),
                  ),
                ).then((value) => _openFile());
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(_items[currentPage-1][index].image),
                  ),
                ),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appTitle),
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: <Color>[Colors.lightBlueAccent, Colors.blue]),
          ),
        ),
      ),
        body: Stack(
            children: <Widget>[
              Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _decideImageView(),
                        ElevatedButton(
                            onPressed: () {
                              _showChoiceDialog(context);
                            },
                            child: Text("Wybierz zdjecie"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent,
                            )),
                        Row(mainAxisAlignment: MainAxisAlignment.center)
                      ],
                    ),
                  )),
              Positioned(
                  right: 5.0,
                  bottom: 5.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffFEBD2B),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Text('$currentPage/$allPages',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
              ),
            ]),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlueAccent,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.content_copy_rounded),
                tooltip: 'Skopiuj',
                color: Colors.white,
                onPressed: () {  },
                ),
              IconButton(
                  icon: Icon(Icons.text_format),
                  tooltip: 'Tekst',
                  color: Colors.white,
                  onPressed: () {  },
                ),
              IconButton(
                icon: Icon(Icons.edit),
                tooltip: 'Upiększ',
                color: Colors.white, onPressed: () {  },
              ),
              IconButton(
                icon: Icon(Icons.photo_filter),
                tooltip: 'Filtry',
                color: Colors.white,
                onPressed: () {  },
              ),
              IconButton(
                icon: Icon(Icons.arrow_left),
                tooltip: 'Poprzednia strona',
                color: Colors.white,
                onPressed: ()=> {
                  if(currentPage>1) {
                    setState(() => currentPage--)
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_right),
                tooltip: 'Następna strona',
                color: Colors.white,
                onPressed: ()=> {
                  if(currentPage<allPages) {
                    setState(() => currentPage++)
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.add_to_photos),
              tooltip: 'Nowa Strona',
              color: Colors.white,
                onPressed: ()=> {
                  _increment()
                },
              )
            ]
      ),
    ));
  }
}
