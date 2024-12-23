import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr_12/src/models/game_model.dart';
import 'package:pr_12/src/resources/api.dart';
import 'package:pr_12/src/ui/components/info.dart';
import 'package:pr_12/src/ui/pages/edit_game_page.dart';


class InfoPage extends StatefulWidget {
  const InfoPage({super.key, required this.gameId});
  final int gameId;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool isFavorite = false;
  final Dio dio = Dio();
  late Game game;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGame();
    _checkFavoriteStatus();
  }
  //Проверка для избранного
  Future<void> _checkFavoriteStatus() async {
    try {
      final response = await dio.get(
        'http://$url/favorites/1/${game.id}',
      );
      setState(() {
        isFavorite = response.statusCode == 200;
      });
    } catch (e) {
      print("Ошибка проверки статуса избранного: $e");
    }
  }

  Future<void> _fetchGame() async {
    try {
      final fetchedGame = await ApiService().getProductById(widget.gameId);
      setState(() {
        game = fetchedGame;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching game: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteGame() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text('Удалить игру',
              style: TextStyle(
                color: Color.fromRGBO(76, 23, 0, 1.0),
                fontWeight: FontWeight.w500,
              )),
        ),
        content: const Text('Вы уверены, что хотите удалить эту игру?',
            style: TextStyle(
              color: Color.fromRGBO(76, 23, 0, 1.0),
              fontWeight: FontWeight.w400,
              fontSize: 16,
            )),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    await ApiService().deleteProduct(game.id);
                    Navigator.of(context).pop();
                  } catch (e) {
                    print("Error deleting game: $e");
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Да',
                    style: TextStyle(
                      color: Color.fromRGBO(21, 78, 24, 1.0),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    )),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Нет',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _updateGameInfo(Game updatedGame) async {
    try {
      await ApiService().updateGameInfo(game.id, updatedGame);
      setState(() {
        game = updatedGame;
      });
    } catch (e) {
      print("Error updating game info: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name, style: TextStyle(
          color: game.colorInd == 1 ? const Color.fromRGBO(129, 40, 0, 1.0) : game.colorInd == 2 ? const Color.fromRGBO(163, 3, 99, 1.0) : const Color.fromRGBO(48, 0, 155, 1.0),
          fontSize: 28,
          fontWeight: FontWeight.w600,
        )),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: <Widget>[

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  if (isFavorite) {
                    await ApiService().removeFromFavorites(game.id, FirebaseAuth.instance.currentUser!.uid);
                  } else {
                    await ApiService().addToFavorites(game.id, FirebaseAuth.instance.currentUser!.uid);
                  }
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: game.colorInd == 1 ? const Color.fromRGBO(129, 40, 0, 1.0) : game.colorInd == 2 ? const Color.fromRGBO(163, 3, 99, 1.0) : const Color.fromRGBO(48, 0, 155, 1.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditGamePage(game: game)),
                    );
                    if (result != null && result is Game) {
                      _updateGameInfo(result);
                    }
                  },
                  child: Icon(
                    Icons.edit,
                    color: game.colorInd == 1 ? const Color.fromRGBO(129, 40, 0, 1.0) : game.colorInd == 2 ? const Color.fromRGBO(163, 3, 99, 1.0) : const Color.fromRGBO(48, 0, 155, 1.0),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: game.colorInd == 1 ? const Color.fromRGBO(129, 40, 0, 1.0) : game.colorInd == 2 ? const Color.fromRGBO(163, 3, 99, 1.0) : const Color.fromRGBO(48, 0, 155, 1.0)),
                onPressed: _deleteGame,
              ),
            ],
          ),
          InfoUi(game: game,
              textColor: game.colorInd == 1 ? const Color.fromRGBO(129, 40, 0, 1.0) : game.colorInd == 2 ? const Color.fromRGBO(163, 3, 99, 1.0) : const Color.fromRGBO(48, 0, 155, 1.0),
              nameColor: game.colorInd == 1 ? 'brown' : game.colorInd == 2 ? 'pink' : 'blue'
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 10.0, right: 15.0, left: 15.0),
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditGamePage(game: game)),
                );
                if (result != null && result is Game) {
                  _updateGameInfo(result);
                }
              },
              child: Container(
                width: 120,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                        color: game.colorInd == 1 ? const Color.fromRGBO(129, 40, 0, 1.0) : game.colorInd == 2 ? const Color.fromRGBO(163, 3, 99, 1.0) : const Color.fromRGBO(48, 0, 155, 1.0),
                        width: 2
                    )
                ),
                child: Center(
                  child: Text('Редактировать игру',
                      style: TextStyle(
                        fontSize: 16,
                        color: game.colorInd == 1 ? const Color.fromRGBO(129, 40, 0, 1.0) : game.colorInd == 2 ? const Color.fromRGBO(163, 3, 99, 1.0) : const Color.fromRGBO(48, 0, 155, 1.0),
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 10.0, right: 15.0, left: 15.0),
            child: GestureDetector(
              onTap: _deleteGame,
              child: Container(
                width: 120,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                        color: Colors.redAccent,
                        width: 2
                    )
                ),
                child: const Center(
                  child: Text('Удалить игру',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

