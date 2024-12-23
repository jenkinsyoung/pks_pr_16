import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr_12/src/models/user_model.dart';
import 'package:pr_12/src/resources/api.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final Dio _dio = Dio();

  late UserFromDB _user;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        final response = await _dio.get('http://$url/user/${currentUser.uid}');
        if (response.statusCode == 200) {
          setState(() {
            _user = UserFromDB.fromJson(response.data);
            _usernameController.text = _user.username;
            _imageController.text = _user.image;
            _phoneController.text = _user.phone;
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
  Future<void> _updateProfile() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        _user.username = _usernameController.text;
        _user.image = _imageController.text;
        _user.phone = _phoneController.text;

        final response = await _dio.post(
          'http://$url/user/${currentUser.uid}',
          data: {
            "user_id": currentUser.uid,
            "username": {
              "String": _usernameController.text,
              "Valid": _usernameController.text.isNotEmpty
            },
            "phone": {
              "String": _phoneController.text.isNotEmpty ? _phoneController.text : "",
              "Valid": _phoneController.text.isNotEmpty
            },
            "image": {
              "String": _imageController.text,
              "Valid": _imageController.text.isNotEmpty
            }
          },
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
        } else {
          throw Exception('Failed to update profile');
        }
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Имя пользователя'),
            ),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Url аватарки'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Тел. номер'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Сохранить данные'),
            ),
          ],
        ),
      ),
    );
  }
}

