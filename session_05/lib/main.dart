import 'package:flutter/material.dart';
import 'image_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Demo',
      debugShowCheckedModeBanner: false,
      home: const ImagePage(),
    );
  }
}