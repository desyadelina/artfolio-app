// ignore_for_file: file_names

import 'package:artfolio_app/components/appbar.dart';
import 'package:artfolio_app/pages/profile.dart';
import 'package:flutter/material.dart';

class FormUploadPage extends StatefulWidget {
  const FormUploadPage({super.key});

  @override
  State<FormUploadPage> createState() => _FormUploadPageState();
}

class _FormUploadPageState extends State<FormUploadPage> {
  final _formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final description = TextEditingController();
  final link = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: 'Create Portfolio',
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  "Title",
                  style: TextStyle(
                    color: Color.fromRGBO(222, 222, 222, 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextFormField(
                controller: title,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Tell everyone what your art is about",
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(222, 222, 222, 0.3),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Title are required";
                  }
                  return null;
                },
              ),
              const Divider(color: Color.fromARGB(67, 222, 222, 222)),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  "Description",
                  style: TextStyle(
                    color: Color.fromRGBO(222, 222, 222, 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextFormField(
                controller: description,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Add a description to your art",
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(222, 222, 222, 0.3),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                  border: InputBorder.none,
                ),
              ),
              const Divider(color: Color.fromARGB(67, 222, 222, 222)),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  "Link",
                  style: TextStyle(
                    color: Color.fromRGBO(222, 222, 222, 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextFormField(
                controller: link,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Add link here",
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(222, 222, 222, 0.3),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                  border: InputBorder.none,
                ),
              ),
              const Divider(color: Color.fromARGB(67, 222, 222, 222)),
              const SizedBox(height: 5),
              const Text(
                "If you repost illegally content, etc. we may remove or block access to the content, and you may be subject to punishment pursuant to relevant laws and regulations.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(222, 222, 222, 0.498),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 85,
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5307),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Create",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
