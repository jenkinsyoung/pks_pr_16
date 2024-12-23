import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr_12/src/models/favorite_model.dart';
import 'package:pr_12/src/models/game_model.dart';
import 'package:pr_12/src/resources/api.dart';
import 'package:pr_12/src/ui/components/game_card.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Game>> _products;
  late Future<List<Favorite>> _favorites;

  @override
  void initState() {
    super.initState();
    _products = ApiService().getProducts();
    _favorites = ApiService().getFavorites(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Избранное',
            style: TextStyle(
              color: Color.fromRGBO(76, 23, 0, 1.0),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
          future: _favorites,
          builder: (context, favoritesSnapshot){
            if (favoritesSnapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            if (!favoritesSnapshot.hasData || favoritesSnapshot.data!.isEmpty){
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 20.0,
                    left: 20.0,
                  ),
                  child: Text(
                    'У Вас нет избранных игр',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(76, 23, 0, 1.0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return FutureBuilder<List<Game>>(
              future: _products,
              builder: (context, productSnapshot) {
                if (productSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                }
                final products = productSnapshot.data!;
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 15.0,
                  ),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      childAspectRatio: 161 / 205,
                    ),
                    itemCount: favoritesSnapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = favoritesSnapshot.data![index];
                      final product = products.firstWhere((p) => p.id == item.gameId);
                      return GestureDetector(
                        onTap: () async {
                          // final result = await Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => InfoPage(game: item),
                          //   ),
                          // );
                          // if (result is Item) {
                          //   setState(() {
                          //     favoriteItems[index] = result;
                          //   });
                          // }
                        },
                        child: GameCard(
                          game: product,
                          bodyColor: product.colorInd == 1 ? const Color.fromRGBO(255, 207, 2, 1.0) : product.colorInd == 2 ? const Color.fromRGBO(163, 3, 99, 1.0) : const Color.fromRGBO(48, 0, 155, 1.0),
                          textColor: product.colorInd == 1 ? const Color.fromRGBO(129, 40, 0, 1.0) : product.colorInd == 2 ? const Color.fromRGBO(255, 204, 254, 1.0) : const Color.fromRGBO(203, 238, 251, 1.0),
                        ),
                      );
                    },
                  ),
                );
              }
            );
          })

    );
  }
}
