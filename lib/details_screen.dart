import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stick_it/stick_it.dart';

class DetailScreen extends StatelessWidget {
  final File image;

  DetailScreen({Key? key, required this.image}) : super(key: key);

  _deleteFile() async {
    await image.delete();
  }

  _saveFile() async {
    final newImage = await _stickIt.exportImage();
    image.writeAsBytesSync(newImage);
  }

  late StickIt _stickIt;

  @override
  Widget build(BuildContext context) {
    _stickIt = StickIt(
      stickerList: [
        Image.asset('assets/icons8-anubis-48.png'),
        Image.asset('assets/icons8-bt21-shooky-48.png'),
        Image.asset('assets/icons8-fire-48.png'),
        Image.asset('assets/icons8-jake-48.png'),
        Image.asset('assets/icons8-keiji-akaashi-48.png'),
        Image.asset('assets/icons8-mate-48.png'),
        Image.asset('assets/icons8-pagoda-48.png'),
        Image.asset('assets/icons8-spring-48.png'),
        Image.asset('assets/icons8-totoro-48.png'),
        Image.asset('assets/icons8-year-of-dragon-48.png'),
      ],
      key: UniqueKey(),
      stickerSize: 100,
      panelBackgroundColor: Colors.white,
      panelStickerBackgroundColor: Theme.of(context).primaryColorLight,
      child: Image.file(image),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły zdjęcia'),
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
        children: [
          _stickIt,
          Positioned(
            bottom: MediaQuery.of(context).size.height / 4,
            right: MediaQuery.of(context).size.width / 12,
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      _deleteFile();
                      Navigator.pop(context);
                    },
                    child: Text("Usuń zdjęcie"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                    )),
                ElevatedButton(
                    onPressed: () {
                      _saveFile();
                    },
                    child: Text("Zapisz zdjęcie"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                    )),
              ],
              /// The [StickIt] Class only requires two named parameters.
              ///
              /// [Widget] child - the child that the stickers should be placed upon.
              /// [List<Image>] stickerList - the list of stickers available to the user.
              ///
              /// StickIt supports a lot of styling related optional named parameters,
              /// that you can change and check out in the AdvancedExample. (tbd)
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoItem {
  final File image;

  PhotoItem(this.image);
}
