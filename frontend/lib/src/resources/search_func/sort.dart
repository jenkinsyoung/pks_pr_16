import 'package:pr_12/src/models/game_model.dart';
// 1 - сортировка от А до Я
// 2 - сортировка от Я до А
// 3 - сортировка по возрастанию цены
// 4 - сорторовка по убыванию цены
// else - нет сортировки
List<Game> sort (List<Game> games, int param) {
  List<Game> sortedProducts = games;
  if (param == 1){
    sortedProducts.sort((a, b) => a.name.compareTo(b.name));
  }
  else if (param == 2){
    sortedProducts.sort((a, b) => a.name.compareTo(b.name));
    sortedProducts = sortedProducts.reversed.toList();
  }
  else if (param == 3){
    sortedProducts.sort((a, b) => a.price.compareTo(b.price));
  }
  else if (param == 4){
    sortedProducts.sort((a, b) => a.price.compareTo(b.price));
    sortedProducts = sortedProducts.reversed.toList();
  }
  else{
    return games;
  }
  return sortedProducts;
}