import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../ui/pages/basket_page.dart';
import '../ui/pages/favorite_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/profile_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final List<Widget>  widgetOptions = <Widget>[
                const HomePage(),
                const FavoritePage(),
                const BasketPage(),
                const ProfilePage(),
              ];
              return Scaffold(
                body:
                widgetOptions.elementAt(_selectedIndex),
                bottomNavigationBar: BottomNavigationBar(
                  items: const  <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_rounded,
                        color: Color.fromRGBO(76, 23, 0, 1.0),),
                      label: 'Главная',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_rounded,
                        color: Color.fromRGBO(76, 23, 0, 1.0),),
                      label: 'Избранное',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart,
                        color: Color.fromRGBO(76, 23, 0, 1.0),),
                      label: 'Корзина',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person,
                        color: Color.fromRGBO(76, 23, 0, 1.0),),
                      label: 'Профиль',
                    ),

                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: const Color.fromRGBO(76, 23, 0, 1.0),
                  onTap: _onItemTapped,
                ),
              );
            }

            else {
              final List<Widget>  widgetOptions = <Widget>[
                const HomePage(),
                const ProfilePage(),
              ];
              return Scaffold(
                body:
                widgetOptions.elementAt(_selectedIndex),
                bottomNavigationBar: BottomNavigationBar(
                  items: const  <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_rounded,
                        color: Color.fromRGBO(76, 23, 0, 1.0),),
                      label: 'Главная',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person,
                        color: Color.fromRGBO(76, 23, 0, 1.0),),
                      label: 'Профиль',
                    ),

                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: const Color.fromRGBO(76, 23, 0, 1.0),
                  onTap: _onItemTapped,
                ),
              );
            }
          }

      ),
    );
  }
}


