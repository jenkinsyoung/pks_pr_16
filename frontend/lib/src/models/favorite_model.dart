class Favorite{
  final int gameId;

  Favorite(
      {
        required this.gameId,
      }
      );

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      gameId: json['product_id'].toInt()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': gameId
    };
  }
}
