import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Introduction Profile"),
      ),

      body: Center(

        // padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Stanley Wijaya",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Mobile Developer Enthusiast",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Welcome to Flutter! This is a simple introduction page '
              'created as a basic Flutter mini project.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        
        ),

    );


  }

  

}