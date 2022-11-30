import 'dart:io';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final File image;

  const DetailScreen({Key? key, required this.image}) : super(key: key);

  _deleteFile() async {
    await image.delete();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: SizedBox(
              width: double.infinity,
              child: Image(
                image: FileImage(image),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                _deleteFile();
                Navigator.pop(context);
              },
              child: Text("Usuń zdjęcie"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              )),
        ],
      ),
    );
  }
}

class PhotoItem {
  final File image;

  PhotoItem(this.image);
}
