import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {

  /// For Mobile
  File? _selectedImage;

  /// For Web
  Uint8List? _imageBytes;

  final List<String> imageList = [
    "assets/images/img1.jpg",
    "assets/images/img2.jpg",
    "assets/images/img3.jpg",
  ];

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {

      /// If running on Web
      if (kIsWeb) {
        _imageBytes = await picked.readAsBytes();
      } 

      /// If running on Mobile
      else {
        _selectedImage = File(picked.path);
      }

      setState(() {});
    }
  }

  Widget showPickedImage() {

    if (kIsWeb && _imageBytes != null) {
      return Image.memory(
        _imageBytes!,
        height: 200,
      );
    }

    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        height: 200,
      );
    }

    return const Text("No image selected");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Demo"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// ================= IMAGE FROM INTERNET =================
            const Text(
              "Image from URL",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Image.network(
              "https://picsum.photos/400/200",
              height: 200,
            ),

            const SizedBox(height: 30),

            /// ================= IMAGE CAROUSEL =================
            const Text(
              "Image Carousel",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: imageList.map((img) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.asset(
                      img,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            /// ================= IMAGE PICKER =================
            const Text(
              "Image Picker",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            showPickedImage(),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Pick Image from Gallery"),
            ),
          ],
        ),
      ),
    );
  }
}