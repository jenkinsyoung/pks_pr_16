import 'package:flutter/material.dart';
import 'package:pr_12/src/models/game_model.dart';
import 'package:pr_12/src/models/order_model.dart';
import 'package:pr_12/src/resources/api.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.userId});
  final String userId;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<List<Game>> _products;
  late Future<List<Order>> _orders;

  @override
  void initState() {
    super.initState();
    _products = ApiService().getProducts();
    _orders = ApiService().getOrders(widget.userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Мои заказы',
          style: TextStyle(
            color: Color.fromRGBO(76, 23, 0, 1.0),
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<List<Order>>(
        future: _orders,
        builder: (context, orderSnapshot) {
          if (orderSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!orderSnapshot.hasData || orderSnapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'У вас нет заказов',
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
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: orderSnapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = orderSnapshot.data![index];
                  return OrderUI(order: order, products: products);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class OrderUI extends StatelessWidget {
  const OrderUI({
    Key? key,
    required this.order,
    required this.products,
  }) : super(key: key);

  final Order order;
  final List<Game> products;

  @override
  Widget build(BuildContext context) {
    double orderTotal = 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(76, 23, 0, 1.0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          ...order.products.map((orderProduct) {
            final product = products.firstWhere(
                  (p) => p.id == orderProduct.productId,
              orElse: () => Game(
                  id: orderProduct.productId,
                  name: 'Unknown Product',
                  price: 0,
                  image: '',
                  description: '',
                  rules: '',
                  age: 0,
                  gamers: '',
                  gameTime: '',
                  colorInd: 1,
                  stock: 0
              ),
            );

            final productTotal = product.price * orderProduct.quantity;
            orderTotal += productTotal;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                      children: <Widget>[ Container(
                        width: 110,
                        height: 90,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(product.image),
                                fit: BoxFit.cover
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(
                                color: product.colorInd == 1
                                    ? const Color.fromRGBO(129, 40, 0, 1.0)
                                    : product.colorInd == 2
                                    ? const Color.fromRGBO(163, 3, 99, 1.0)
                                    : const Color.fromRGBO(48, 0, 155, 1.0),
                                width: 2
                            )
                        ),
                      ),
                        Positioned(
                          top: 5.0,
                          right: 5.0,
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: product.colorInd == 1
                                  ? const Color.fromRGBO(129, 40, 0, 1.0)
                                  : product.colorInd == 2
                                  ? const Color.fromRGBO(163, 3, 99, 1.0)
                                  : const Color.fromRGBO(48, 0, 155, 1.0),
                              borderRadius: BorderRadius.circular(45),
                            ),
                            child: Center( child: Text('${product.age}+', style: const TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            ),
                            ),
                          ),)
                      ]
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0
                    ),
                    child:
                    SizedBox(
                      width: 195,
                      height: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 195,
                            height: 24,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Text(product.name, style:const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(76, 23, 0, 1.0),
                              ),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 5.0),
                                child: Image( image: AssetImage('lib/assets/groups_${product.colorInd == 1
                                    ? 'brown'
                                    : product.colorInd == 2
                                    ? 'pink'
                                    : 'blue'}.png' ),
                                  width: 14,
                                ),
                              ),
                              Text(product.gamers, style:
                              TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: product.colorInd == 1
                                    ? const Color.fromRGBO(129, 40, 0, 1.0)
                                    : product.colorInd == 2
                                    ? const Color.fromRGBO(163, 3, 99, 1.0)
                                    : const Color.fromRGBO(48, 0, 155, 1.0),
                              )
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Image( image: AssetImage('lib/assets/clock_${product.colorInd == 1
                                    ? 'brown'
                                    : product.colorInd == 2
                                    ? 'pink'
                                    : 'blue'}.png'),
                                  width: 14,
                                ),
                              ),
                              Text(product.gameTime, style:
                              TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: product.colorInd == 1
                                    ? const Color.fromRGBO(129, 40, 0, 1.0)
                                    : product.colorInd == 2
                                    ? const Color.fromRGBO(163, 3, 99, 1.0)
                                    : const Color.fromRGBO(48, 0, 155, 1.0),
                              ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${product.price} ₽', style:
                              const TextStyle(
                                color: Color.fromRGBO(76, 23, 0, 1.0),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              )),
                              Container(
                                height: 23,
                                width: 54,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(
                                        color: const Color.fromRGBO(76, 23, 0, 1.0),
                                        width: 1
                                    )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                        onTap: (){},
                                        child: const Text('-', style:
                                        TextStyle(
                                          color: Color.fromRGBO(76, 23, 0, 1.0),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          height: 1,
                                        )
                                        )
                                    ),
                                    Text('${orderProduct.quantity}',
                                      style:
                                      const TextStyle(
                                        color: Color.fromRGBO(76, 23, 0, 1.0),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        height: 1,
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: (){},
                                        child: const Text('+',
                                          style:
                                          TextStyle(
                                            color: Color.fromRGBO(76, 23, 0, 1.0),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            height: 1,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
          const Divider(),
          // Total Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Общая стоимость:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${orderTotal.toStringAsFixed(2)}₽',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
