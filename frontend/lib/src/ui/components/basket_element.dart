import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr_12/src/models/game_model.dart';
import 'package:pr_12/src/resources/api.dart';

class BasketElementUi extends StatefulWidget {
  const BasketElementUi({super.key, required this.game, required this.textColor,
    required this.colorName,
    required this.counter,
    required this.onQuantityChanged,
  });
  final String colorName;
  final Game game;
  final Color textColor;
  final int counter;
  final Function(int newCounter) onQuantityChanged;
  @override
  State<BasketElementUi> createState() => _BasketElementUiState();
}

class _BasketElementUiState extends State<BasketElementUi> {
  void _increaseCounter() async {
    await ApiService().addToBasket(widget.game.id, widget.counter + 1, FirebaseAuth.instance.currentUser!.uid);
    widget.onQuantityChanged(widget.counter + 1);
  }

  void _decreaseCounter() async {
    if (widget.counter > 1) {
      await ApiService().addToBasket(widget.game.id, widget.counter - 1, FirebaseAuth.instance.currentUser!.uid);
      widget.onQuantityChanged(widget.counter - 1);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: 23.0,
      ),
      child: SizedBox(
        height: 90,
        width: 318,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
                children: <Widget>[ Container(
                  width: 110,
                  height: 90,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.game.image),
                          fit: BoxFit.cover
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                          color: widget.textColor,
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
                        color: widget.textColor,
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Center( child: Text('${widget.game.age}+', style: const TextStyle(
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
                        child: Text(widget.game.name, style:const TextStyle(
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
                          child: Image( image: AssetImage('lib/assets/groups_${widget.colorName}.png' ),
                            width: 14,
                          ),
                        ),
                        Text(widget.game.gamers, style:
                        TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: widget.textColor,
                        )
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Image( image: AssetImage('lib/assets/clock_${widget.colorName}.png'),
                            width: 14,
                          ),
                        ),
                        Text(widget.game.gameTime, style:
                        TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: widget.textColor,
                        ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${widget.game.price} ₽', style:
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
                                  onTap: _decreaseCounter,
                                  child: const Text('-', style:
                                  TextStyle(
                                    color: Color.fromRGBO(76, 23, 0, 1.0),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    height: 1,
                                  )
                                  )
                              ),
                              Text('${widget.counter}',
                                style:
                                const TextStyle(
                                  color: Color.fromRGBO(76, 23, 0, 1.0),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 1,
                                ),
                              ),
                              GestureDetector(
                                  onTap: _increaseCounter,
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
      ),
    );
  }
}

