class Game{
  final int id;
  final String name;
  final String image;
  final String description;
  final String rules;
  final int age;
  final String gamers;
  final String gameTime;
  final double price;
  final int colorInd;
  int stock;

  Game(
      {required this.id,
        required this.name,
        required this.image,
        required this.description,
        required this.rules,
        required this.age,
        required this.gamers,
        required this.gameTime,
        required this.price,
        required this.colorInd,
        required this.stock
      });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
        id: json['product_id'].toInt() ?? 0,
        name: json['name'] ?? '',
        image: json['image'] ?? '',
        description: json['description'] ?? '',
        rules: json['rules'] ?? '',
        age: json['age'].toInt() ?? 0,
        price: json['price'].toDouble() ?? 0,
        gamers: json['gamers'] ?? '',
        gameTime: json['game_time'] ?? '',
        colorInd: json['color_ind'] ?? 1,
        stock: json['stock'].toInt() ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'name': name,
      'image': image,
      'description': description,
      'rules': rules,
      'age': age,
      'price': price,
      'gamers': gamers,
      'game_time': gameTime,
      'color_ind': colorInd,
      'stock': stock
    };
  }
}

