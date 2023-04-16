import 'package:flutter/material.dart';

class ImageDetailScreen extends StatelessWidget {
  final DateTime selectedDate;
  final String imageUrl;

  const ImageDetailScreen({required this.selectedDate, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}の画像"),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
