import 'package:flutter/material.dart';
import 'package:pr_12/src/ui/pages/sing_in.dart';

class ProfileWithoutAuth extends StatelessWidget {
  const ProfileWithoutAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(
              child: Text('Профиль',
              style:
                TextStyle(
                color: Color.fromRGBO(76, 23, 0, 1.0),
                fontSize: 28,
                fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: NetworkImage(''),
                              fit: BoxFit.cover
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              color: const Color.fromRGBO(76, 23, 0, 1.0),
                              width: 2
                          )
                      ),
                    ),
                    const SizedBox(
                      width: 207.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Unknown',
                            style:  TextStyle(
                                fontSize: 20.0,
                                color: Color.fromRGBO(76, 23, 0, 1.0),
                                fontWeight: FontWeight.w600
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 13.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Вы не вошли в систему',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(76, 23, 0, 1.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              ],
            ),
            const SizedBox(height: 13,),
            Center(
              child: ElevatedButton(onPressed: (){
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SingIn(),
                      ),
                    );
                  },
                  child: Text('Войти в аккаунт')),
            )
          ],
        ),
      ),
    );
  }
}

