import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'disease_detail_screen.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final picker = ImagePicker();
  String _classificationResult = '';
  List<dynamic> _diseases = [];

  @override
  void initState() {
    super.initState();
    fetchDiseases();
  }

  Future fetchDiseases() async {
    final response = await http.get(Uri.parse('https://api.yourbackend.com/diseases'));
    if (response.statusCode == 200) {
      setState(() {
        _diseases = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load diseases');
    }
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future classifyImage() async {
    if (_image == null) return;

    // Assuming your API endpoint is /classify and accepts a POST request with an image file
    final request = http.MultipartRequest('POST', Uri.parse('https://api.yourbackend.com/classify'));
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final result = json.decode(responseData);

      setState(() {
        _classificationResult = result['classification'];
      });
    } else {
      throw Exception('Failed to classify image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null ? Text('No image selected.') : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: classifyImage,
              child: Text('Classify Image'),
            ),
            SizedBox(height: 20),
            Text('Classification Result: $_classificationResult'),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _diseases.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_diseases[index]['name']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiseaseDetailScreen(id: _diseases[index]['id']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}