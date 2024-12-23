class BasketItem{
  final int gameId;
  int counter;

  BasketItem(
      {
        required this.gameId,
        required this.counter
      }
      );

  factory BasketItem.fromJson(Map<String, dynamic> json) {
    return BasketItem(
      gameId: json['product_id'].toInt(),
      counter: json['quantity'].toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': gameId,
      'quantity': counter
    };
  }
}
