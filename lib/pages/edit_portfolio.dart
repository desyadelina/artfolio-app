import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:artfolio_app/services/portfolio_service.dart';
import 'package:artfolio_app/components/appbar.dart';
import 'package:artfolio_app/components/button.dart';

class EditPortfolioPage extends StatefulWidget {
  final String portfolioId;
  final Map<String, dynamic> portfolioData;

  const EditPortfolioPage({
    Key? key,
    required this.portfolioId,
    required this.portfolioData,
  }) : super(key: key);

  @override
  _EditPortfolioPageState createState() => _EditPortfolioPageState();
}

class _EditPortfolioPageState extends State<EditPortfolioPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _linkController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.portfolioData['title']);
    _descriptionController =
        TextEditingController(text: widget.portfolioData['description']);
    _linkController = TextEditingController(text: widget.portfolioData['link']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _updatePortfolio() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('portfolio')
            .doc(widget.portfolioId)
            .update({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'link': _linkController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Portfolio updated successfully!')),
        );
        Navigator.pop(
            context, 'updated'); // Mengirim hasil kembali ke ProfilePage
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update portfolio: $e')),
        );
      }
    }
  }

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
        title: "Edit Portfolio",
      ),
      body: SingleChildScrollView(
        child: Form(
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
                  controller: _titleController,
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
                      return "Title is required";
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
                  controller: _descriptionController,
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
                  controller: _linkController,
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
                    height: 35,
                    child: CustomButton(
                      width: 85,
                      height: 35,
                      buttonText: "Update",
                      onPressed: _updatePortfolio,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
