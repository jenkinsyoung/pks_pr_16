import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr_12/src/models/user_model.dart';
import 'package:pr_12/src/resources/api.dart';
import 'package:pr_12/src/resources/auth_gate.dart';
import 'package:pr_12/src/resources/auth_service.dart';
import 'package:pr_12/src/ui/components/profile.dart';
import 'package:pr_12/src/ui/pages/admin_chat_page.dart';
import 'package:pr_12/src/ui/pages/chat_page.dart';
import 'package:pr_12/src/ui/pages/edit_profile_page.dart';
import 'package:pr_12/src/ui/pages/order_page.dart';
import 'package:pr_12/src/ui/pages/profile_without_auth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserFromDB? _userFromDB;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchUser(String id) async {
    try {
      final user = await ApiService().getUser(id);
      setState(() {
        _userFromDB = user;
        _isLoading = false;
      });

    } catch (error) {
      if (error.toString().contains('404')) {
        print('User not found, creating new user...');
        try {
          final newUser = UserFromDB(
              userId: _auth.currentUser!.uid,
              username: '',
              email: _auth.currentUser!.email.toString(),
              password: '',
              image: '',
              phone: '',
              role: 'user');
          print('${newUser.toJson()}');
          await ApiService().addUser(newUser);
          final user = await ApiService().getUser(id);
          setState(() async {
            _userFromDB =  user;
            _isLoading = false;
          });
          print('New user created');
        } catch (createError) {
          setState(() {
            _isLoading = false;
          });
          print('Error creating user: $createError');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Error fetching user: $error');
      }
    }
  }
  void signOut(){
    final authService = AuthService();
    authService.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AuthGate())
    );
  }
  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return const ProfileWithoutAuth();
    }
    if (_isLoading) {
      _fetchUser(user.uid);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Профиль',
            style: TextStyle(
              color: Color.fromRGBO(76, 23, 0, 1.0),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color.fromRGBO(76, 23, 0, 1.0),),
            onPressed: signOut,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userFromDB == null
          ? const Center(child: Text('Не удалось загрузить данные пользователя'))
          : Column(
        children: [
          Profile(user: _userFromDB!),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(350, 40),
                textStyle: const TextStyle(
                  fontSize: 14,
                )),
            child: const Text('Редактировать профиль'),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrderPage(userId: _auth.currentUser!.uid),
                ),
              );
            },
            child: Container(
              width: 350,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(129, 40, 0, 1),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8)
              ),
              child: const Center(
                child: Text('Мои заказы >>', style:
                  TextStyle(
                    color: Color.fromRGBO(129, 40, 0, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _userFromDB!.email != 'poloshkova.a.y@edu.mirea.ru' ?
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChatPage(
                      receiverUserEmail: 'poloshkova.a.y@edu.mirea.ru',
                      receiverUserId: 'LLkXc6JqqcZ1M45sKjB5zxE4JNL2'),
                ),
              );
            },
            child: Container(
              width: 350,
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(129, 40, 0, 1),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8)
              ),
              child: const Center(
                child: Text('Чат с продавцом >>', style:
                TextStyle(
                  color: Color.fromRGBO(129, 40, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                )
                ),
              ),
            ),
          ) :
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AdminChatPage(),
                )
              );
            },
            child: Container(
              width: 350,
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(129, 40, 0, 1),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8)
              ),
              child: const Center(
                child: Text('Мои чаты >>', style:
                TextStyle(
                  color: Color.fromRGBO(129, 40, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                )
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
