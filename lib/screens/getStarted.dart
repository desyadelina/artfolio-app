import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artfolio App'),
      ),
      body: const Center(
        child: Text('Hello world'),
      ),
    );
  }
}