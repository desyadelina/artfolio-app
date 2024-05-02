import 'package:flutter/material.dart';

class FormUploadPage extends StatefulWidget {
  const FormUploadPage({super.key});

  @override
  State<FormUploadPage> createState() => _FormUploadPageState();
}

class _FormUploadPageState extends State<FormUploadPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Form Page',
          style: TextStyle(
            fontSize: 100,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
