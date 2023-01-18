import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stick_it/stick_it.dart';

class DetailScreen extends StatelessWidget {
  final File image;

  DetailScreen({Key? key, required this.image}) : super(key: key);

  _deleteFile() async {
    if(await image.exists()) {
      await image.delete().catchError((e) => print(e));
    } else {
      print("File not found");
    }
  }

  _saveFile() async {
    final newImage = await _stickIt.exportImage();
    var fileName = "${image.path}_1.jpg";
    await image.delete();
    final file = await File(fileName).create();
    file.writeAsBytesSync(newImage, flush: true);
  }

  late StickIt _stickIt;

  @override
  Widget build(BuildContext context) {
    _stickIt = StickIt(
      stickerList: [
        Image.asset('assets/candle.png'),
        Image.asset('assets/honeymoon.png'),
        Image.asset('assets/invitation.png'),
        Image.asset('assets/love.png'),
        Image.asset('assets/wedding.png'),
        Image.asset('assets/wedding-arch.png'),
        Image.asset('assets/wedding-arch-2.png'),
        Image.asset('assets/wedding-cake.png'),
        Image.asset('assets/wedding-ring.png'),
        Image.asset('assets/wedding-rings.png'),
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
                    onPressed: () async {
                      await _deleteFile();
                      Navigator.pop(context);
                    },
                    child: Text("Usuń zdjęcie"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                    )),
                ElevatedButton(
                    onPressed: () async {
                      await _saveFile();
                      Navigator.pop(context);
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
