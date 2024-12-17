import 'dart:io';
import 'package:artfolio_app/components/button.dart';
import 'package:artfolio_app/components/index.dart';
import 'package:artfolio_app/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:artfolio_app/components/appbar.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final displayNameController = TextEditingController();
  final usernameController = TextEditingController();
  final descriptionController = TextEditingController();
  XFile? _profileImage;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      ProfileService profileService = ProfileService();
      var profileData = await profileService.getProfile();
      if (profileData != null) {
        displayNameController.text = profileData['displayName'] ?? '';
        usernameController.text = profileData['username'] ?? '';
        descriptionController.text = profileData['description'] ?? '';
        setState(() {
          if (profileData['profileImageUrl'] != null) {
            _profileImageUrl = profileData[
                'profileImageUrl']; // Store existing profile image URL
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ProfileService().updateProfile(
          displayName: displayNameController.text,
          username: usernameController.text,
          description: descriptionController.text,
          profileImage: _profileImage,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Index(initialIndex: 3),
          ),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
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
        title: "Edit Profile",
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? FileImage(File(_profileImage!.path))
                                  as ImageProvider
                              : _profileImageUrl != null
                                  ? NetworkImage(_profileImageUrl!)
                                      as ImageProvider
                                  : null,
                          backgroundColor: Colors.grey[800],
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Text(
                              "Change photo",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    "Display name",
                    style: TextStyle(
                      color: Color.fromRGBO(222, 222, 222, 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextFormField(
                  controller: displayNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Type your name",
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
                      return "Display name is required";
                    }
                    return null;
                  },
                ),
                const Divider(color: Color.fromARGB(67, 222, 222, 222)),
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    "Username",
                    style: TextStyle(
                      color: Color.fromRGBO(222, 222, 222, 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextFormField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Add username",
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
                    "Additional Info",
                    style: TextStyle(
                      color: Color.fromRGBO(222, 222, 222, 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Add more information about yourself",
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
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 314,
                    height: 40,
                    child: CustomButton(
                      onPressed: _saveProfile,
                      buttonText: 'Save changes',
                      width: 314,
                      height: 40,
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
