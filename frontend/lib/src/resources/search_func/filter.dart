import 'package:pr_12/src/models/game_model.dart';
// price - фильтр по минимальной и максимальной стоимости
List<Game> filter(List<Game> games, int? minPrice, int? maxPrice) {
  return games.where((game) =>
  (game.price >= minPrice! && game.price <= maxPrice!)
  ).toList();
}