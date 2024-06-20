import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'disease_detail_screen.dart';
import 'overview_page.dart'; // Import the Overview Page

class ImageUploadScreen extends StatefulWidget {
  final bool fromCamera;

  const ImageUploadScreen({Key? key, required this.fromCamera}) : super(key: key);

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;
  String _classificationResult = '';
  List<dynamic> _diseases = [];

  @override
  void initState() {
    super.initState();
    fetchDiseases();
    pickImage();
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
    final pickedFile = await picker.pickImage(source: widget.fromCamera ? ImageSource.camera : ImageSource.gallery);
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

    setState(() {
      _isLoading = true;
    });

    final request = http.MultipartRequest('POST', Uri.parse('https://api'));
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final result = json.decode(responseData);

      setState(() {
        _classificationResult = result['classification'];
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OverviewPage(classification: _classificationResult, image: _image!),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to classify image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Center(
        child: SingleChildScrollView( // Wrap with SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image == null ? const Text('No image selected.') : Image.file(_image!),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: classifyImage,
                child: const Text('Classify Image'),
              ),
              const SizedBox(height: 20),
              Text('Classification Result: $_classificationResult'),
              const SizedBox(height: 20),
              // Wrap ListView.builder with a Container of limited height
              SizedBox(
                height: 200, // Set a fixed height for the list
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
      ),
    );
  }
}
