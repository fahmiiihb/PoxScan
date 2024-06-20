import 'package:flutter/material.dart';
import 'dart:io';

class OverviewPage extends StatelessWidget {
  final String classification;
  final File image;

  const OverviewPage({Key? key, required this.classification, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$classification (Lorem ipsum)'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.file(image, width: 150, height: 150),
                  Image.file(image, width: 150, height: 150), // Placeholder for Disease Image
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Overview',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Recommendation Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150, // Set height for the recommendations list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4, // Replace with the actual number of recommendations
                  itemBuilder: (context, index) {
                    return Container(
                      width: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.grey[300],
                      child: const Center(child: Text('Lorem ipsum')),
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
