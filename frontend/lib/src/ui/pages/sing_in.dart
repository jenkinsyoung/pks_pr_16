import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr_12/src/resources/auth_gate.dart';
import 'package:pr_12/src/resources/auth_service.dart';
import 'package:pr_12/src/ui/components/my_button.dart';
import 'package:pr_12/src/ui/components/my_text_field.dart';
import 'package:pr_12/src/ui/pages/sign_up.dart';

class SingIn extends StatefulWidget {
  const SingIn({super.key});

  @override
  State<SingIn> createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void signIn() async{
    final authService = AuthService();

    try{
      UserCredential userCredential = await authService.signIn(
        _emailController.text,
        _passwordController.text,
      );
      User? user = userCredential.user;
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthGate()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign in.')),
        );
      }
      } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Вход', style: TextStyle(color: Color.fromRGBO(76, 23, 0, 1.0),
        fontSize: 28,
        fontWeight: FontWeight.w600,)))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(controller: _emailController,
                obscureText: false,
                hintText: 'Почта'
            ),
            MyTextField(controller: _passwordController,
                obscureText: true,
                hintText: 'Пароль'
            ),
            const SizedBox(height: 20),
            MyButton(onTap: signIn, text: 'Войти'),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUp()),
                );
              },
              child: const Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}