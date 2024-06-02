import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiseaseDetailScreen extends StatelessWidget {
  final int id;

  DiseaseDetailScreen({required this.id});

  Future<Map<String, dynamic>?> fetchDiseaseDetail() async {
    final response = await http.get(Uri.parse('https://api.yourbackend.com/diseases/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load disease detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disease Detail'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchDiseaseDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          } else {
            final disease = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${disease['name'] ?? 'N/A'}'),
                  Text('Description: ${disease['description'] ?? 'N/A'}'),
                  // Add more fields as necessary
                ],
              ),
            );
          }
        },
      ),
    );
  }
}