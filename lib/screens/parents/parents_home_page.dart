import 'package:flutter/material.dart';

class ParentsHomePage extends StatelessWidget {
  const ParentsHomePage({super.key, required parentName, required parentPhotoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parents Home Page'),
      ),
      body: const Center(
        child: Text(
          'Welcome, Parent!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
