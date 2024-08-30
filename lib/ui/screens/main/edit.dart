import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/logic/services/auth_service.dart';
import 'package:recipe_app/ui/screens/main/home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _picker = ImagePicker();
  XFile? _imageFile;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userData = await _authService.getCurrentUser();
    setState(() {
      _nameController.text = userData['data']['name'] ?? '';
      // Load current avatar if available
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _updateProfile() async {
    await _authService.updateProfile(
      name: _nameController.text,
      photo: File(_imageFile!.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (ctx) {
                  return HomeScreen();
                },
              ),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 20),
            _imageFile == null
                ? Text('No image selected.')
                : Image.file(
                    File(_imageFile!.path),
                    height: 150,
                  ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
