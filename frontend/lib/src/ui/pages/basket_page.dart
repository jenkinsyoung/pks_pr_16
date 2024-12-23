import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr_12/src/models/basket_model.dart';
import 'package:pr_12/src/models/game_model.dart';
import 'package:pr_12/src/resources/api.dart';
import 'package:pr_12/src/ui/components/basket_element.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  late Future<List<Game>> _products;
  late Future<List<BasketItem>> _basket;
  late Future<double> totalPrice;

  @override
  void initState() {
    super.initState();
    _products = ApiService().getProducts();
    _basket = ApiService().getBasket(FirebaseAuth.instance.currentUser!.uid);
    totalPrice = _calculateTotalPrice();
  }

  Future<double> _calculateTotalPrice() async {
    final basketItems = await _basket;
    final products = await _products;

    double total = 0;
    for (var basketItem in basketItems) {
      final product = products.firstWhere((p) => p.id == basketItem.gameId);
      total += product.price * basketItem.counter;
    }

    return total;
  }

  Future<void> _deleteGame(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text('Удалить игру из корзины',
              style: TextStyle(
                color: Color.fromRGBO(76, 23, 0, 1.0),
                fontWeight: FontWeight.w500,
                fontSize: 20,
              )),
        ),
        content: FutureBuilder<List<Game>>(
          future: _products,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              final product = snapshot.data!.firstWhere((p) => p.id == id);
              return Text(
                'Вы уверены, что хотите удалить "${product.name}"?',
                style: const TextStyle(
                  color: Color.fromRGBO(76, 23, 0, 1.0),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  await ApiService().removeFromBasket(id, FirebaseAuth.instance.currentUser!.uid);
                  setState(() {
                    _basket = ApiService().getBasket(FirebaseAuth.instance.currentUser!.uid);
                    totalPrice = _calculateTotalPrice();
                  });
                  Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Корзина',
            style: TextStyle(
              color: Color.fromRGBO(76, 23, 0, 1.0),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<BasketItem>>(
        future: _basket,
        builder: (context, basketSnapshot) {
          if (basketSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!basketSnapshot.hasData || basketSnapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Ваша корзина пуста',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(76, 23, 0, 1.0),
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
              return Column(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: basketSnapshot.data!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final basketItem = basketSnapshot.data![index];
                      final product = products.firstWhere((p) => p.id == basketItem.gameId);

                      return Dismissible(
                        key: Key(basketItem.gameId.toString()),
                        confirmDismiss: (direction) async {
                          _deleteGame(basketItem.gameId);
                          return false;
                        },
                        child: BasketElementUi(
                          key: Key(basketItem.gameId.toString()),
                          game: product,
                          colorName: product.colorInd == 1
                              ? 'brown'
                              : product.colorInd == 2
                              ? 'pink'
                              : 'blue',
                          textColor: product.colorInd == 1
                              ? const Color.fromRGBO(129, 40, 0, 1.0)
                              : product.colorInd == 2
                              ? const Color.fromRGBO(163, 3, 99, 1.0)
                              : const Color.fromRGBO(48, 0, 155, 1.0),
                          counter: basketItem.counter,
                          onQuantityChanged: (newCounter) {

                            setState(() {
                              basketItem.counter = newCounter;
                              totalPrice = _calculateTotalPrice();
                            });
                          },
                        ),
                      );
                    },
                  ),

                  FutureBuilder<double>(
                    future: totalPrice,
                    builder: (context, priceSnapshot) {
                      if (priceSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        children: [
                          Center(
                            child: Container(
                              width: 324,
                              height: 1, // Change height to 1 for a visible line
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color.fromRGBO(76, 23, 0, 1.0), width: 1.5),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              right: 35.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 15.0),
                                  child: Text(
                                    'Итог:',
                                    style: TextStyle(
                                      color: Color.fromRGBO(76, 23, 0, 1.0),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${priceSnapshot.data?.toStringAsFixed(2) ?? 0} ₽',
                                  style: const TextStyle(
                                    color: Color.fromRGBO(76, 23, 0, 1.0),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  final basketItems = await _basket;
                                  await ApiService().createOrder(basketItems, priceSnapshot.data ?? 0.0, FirebaseAuth.instance.currentUser!.uid);

                                  await ApiService().clearBasket(basketItems, FirebaseAuth.instance.currentUser!.uid);


                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Заказ оформлен!'),
                                      content: const Text('Ваш заказ успешно отправлен, корзина очищена.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );

                                  setState(() {
                                    _basket = ApiService().getBasket(FirebaseAuth.instance.currentUser!.uid);
                                  });
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Ошибка'),
                                      content: Text('Не удалось оформить заказ: $e'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: 330,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color.fromRGBO(129, 40, 0, 1),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: const Center(
                                  child: Text('Оформить заказ', style:
                                  TextStyle(
                                    color: Color.fromRGBO(129, 40, 0, 1),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  )
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
