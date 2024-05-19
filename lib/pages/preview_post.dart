// ignore_for_file: prefer_const_constructors, file_names

import 'package:artfolio_app/components/appbar.dart';
import 'package:flutter/material.dart';

class PreviewPost extends StatelessWidget {
  const PreviewPost({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xDEDEDEDE),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              
            },
          ),
        ],
      ),
    );
  }
}
