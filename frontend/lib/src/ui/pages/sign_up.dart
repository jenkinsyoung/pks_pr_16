
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr_12/src/models/user_model.dart';
import 'package:pr_12/src/resources/api.dart';
import 'package:pr_12/src/resources/auth_service.dart';
import 'package:pr_12/src/ui/components/my_button.dart';
import 'package:pr_12/src/ui/components/my_text_field.dart';
import 'package:pr_12/src/ui/pages/sing_in.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void signUp () async{
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _passwordConfirmController.text;

    if (password != confirmPassword){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пароли не совпадают'))
      );
    }
    else{
      final authService = AuthService();
      try{
        final response = await authService.signUp(email, password);
        final user = response.user;

        if (user == null){
          throw Exception('Fail to get user information');
        }

        await ApiService().addUser(UserFromDB(
            userId: user.uid,
            username: _nicknameController.text,
            image: '',
            email: email,
            phone: _phoneController.text,
            password: password,
            role: 'user'
        )
        );

        Navigator.pop(context);
      }
      catch (e){
        if (mounted){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: const Color.fromRGBO(44, 32, 17, 1.0),
                  content: Text('Ошибка: $e')
              )
          );
        }
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Регистрация',
            style: TextStyle(
              color: Color.fromRGBO(76, 23, 0, 1.0),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(
                controller: _nicknameController,
                obscureText: false,
                hintText: 'Имя пользователя'
            ),
            MyTextField(
                controller: _emailController,
                obscureText: false,
                hintText: 'Почта'
            ),
            MyTextField(
                controller: _passwordController,
                obscureText: true,
                hintText: 'Пароль'
            ),
            MyTextField(
                controller: _passwordConfirmController,
                obscureText: true,
                hintText: 'Повторный пароль'
            ),
            MyTextField(
                controller: _phoneController,
                obscureText: false,
                hintText: 'Тел. номер'
            ),
            const SizedBox(height: 20),
            MyButton(onTap: signUp, text: 'Зарегистрироваться'),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SingIn()),
                );
              },
              child: const Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}


