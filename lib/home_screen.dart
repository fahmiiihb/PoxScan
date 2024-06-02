import 'package:flutter/material.dart';
import 'image_upload_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PoxScan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png', width: 150, height: 150),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Take Picture'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageUploadScreen(fromCamera: true)),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Upload Image'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageUploadScreen(fromCamera: false)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}