import 'package:pr_12/src/models/game_model.dart';

List<Game> search (List<Game> games, String query){
  List<Game> result = [];
  result = games.where((game) => game.name.toLowerCase().contains(query.toLowerCase()) || game.description.toLowerCase().contains(query.toLowerCase())).toList();
  return result;
}