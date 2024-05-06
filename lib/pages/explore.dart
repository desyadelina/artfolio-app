import 'package:artfolio_app/components/appbar.dart';
import 'package:artfolio_app/components/input.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          const SizedBox(width: 60),
          Expanded(
            child: CustomInput(
              placeholder: 'Search keyword',
              icon: Icons.search_rounded,
              iconColor:  Colors.grey,
              controller: TextEditingController(),
              height: 50,
              width: 340,
            ),
            
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Explorer',
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
