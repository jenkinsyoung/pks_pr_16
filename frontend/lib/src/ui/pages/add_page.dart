import 'package:flutter/material.dart';
import 'package:pr_12/src/models/game_model.dart';
import 'package:pr_12/src/ui/components/game_card.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController gamersController = TextEditingController();
  final TextEditingController rulesController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  String? selectedColor;
  final List<String> colorNames = ["Желтый", "Розовый", "Синий"];

  bool get _isFormValid {
    return imageUrlController.text.isNotEmpty &&
        titleController.text.isNotEmpty &&
        selectedColor != null;
  }

  void _createItem() {
    if (_isFormValid) {
      final newItem = Game(
          id: 0,
          name: titleController.text,
          image: imageUrlController.text,
          description: descriptionController.text,
          rules: rulesController.text,
          age: int.tryParse(ageController.text) ?? 0,
          gamers: gamersController.text,
          gameTime: timeController.text,
          price: double.tryParse(priceController.text) ?? 0,
          colorInd: colorNames.indexOf(selectedColor!) + 1,
          stock: int.tryParse(stockController.text) ?? 0
      );
      Navigator.pop(context, newItem);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление игры',
          style: TextStyle(
            color: Color.fromRGBO(76, 23, 0, 1.0),
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.only(
              right: 15.0,
              left: 15.0,
              top: 5.0
          ),
          child: Column(
            children: [

              if(_isFormValid)
                (colorNames.indexOf(selectedColor!) + 1 == 1)?
                GameCard(game: Game(
                    id: 0,
                    name: titleController.text,
                    image: imageUrlController.text,
                    description: descriptionController.text,
                    rules: rulesController.text,
                    age: int.tryParse(ageController.text) ?? 0,
                    gamers: gamersController.text,
                    gameTime: timeController.text,
                    price: double.tryParse(priceController.text) ?? 0,
                    colorInd: colorNames.indexOf(selectedColor!) + 1,
                    stock: int.tryParse(stockController.text) ?? 0
                ),
                  bodyColor: const Color.fromRGBO(255, 207, 2, 1.0),
                  textColor: const Color.fromRGBO(129, 40, 0, 1.0),
                )
                    : (colorNames.indexOf(selectedColor!) + 1 == 2) ?
                GameCard(game: Game(
                    id: 0,
                    name: titleController.text,
                    image: imageUrlController.text,
                    description: descriptionController.text,
                    rules: rulesController.text,
                    age: int.tryParse(ageController.text) ?? 0,
                    gamers: gamersController.text,
                    gameTime: timeController.text,
                    price: double.tryParse(priceController.text) ?? 0,
                    colorInd: colorNames.indexOf(selectedColor!) + 1,
                    stock: int.tryParse(stockController.text) ?? 0
                ),
                  bodyColor: const Color.fromRGBO(163, 3, 99, 1.0),
                  textColor: const Color.fromRGBO(255, 204, 254, 1.0),
                ):
                GameCard(game: Game(
                    id: 0,
                    name: titleController.text,
                    image: imageUrlController.text,
                    description: descriptionController.text,
                    rules: rulesController.text,
                    age: int.tryParse(ageController.text) ?? 0,
                    gamers: gamersController.text,
                    gameTime: timeController.text,
                    price: double.tryParse(priceController.text) ?? 0,
                    colorInd: colorNames.indexOf(selectedColor!) + 1,
                    stock: int.tryParse(stockController.text) ?? 0
                ),
                  bodyColor: const Color.fromRGBO(48, 0, 155, 1.0),
                  textColor: const Color.fromRGBO(203, 238, 251, 1.0),
                ),
              const SizedBox(height: 10),
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'URL картинки'),
                onChanged: (_) {
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Обязательное поле';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Название игры'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Обязательное поле';
                  }
                  return null;
                },
                onChanged: (_) {
                  setState(() {});
                },
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Цена (в рублях)'),
                keyboardType: TextInputType.number,
                onChanged: (_) {
                  setState(() {});
                },
              ),

              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Возрастное ограничение'),
                keyboardType: TextInputType.number,
                onChanged: (_) {
                  setState(() {});
                },
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Описание игры (кратко)'),
                onChanged: (_) {
                  setState(() {});
                },
              ),
              SizedBox(
                width: 400,
                height: 50,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:  Color.fromRGBO(76, 23, 0, 0.8),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: selectedColor,
                    hint: const Text('Выберите цвет'),
                    items: colorNames
                        .map((color) => DropdownMenuItem<String>(
                      value: color,
                      child: Text(color),
                    ))
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedColor = value;
                      });
                    },
                    isExpanded: true,
                    underline: const SizedBox(),
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    iconEnabledColor: const Color.fromRGBO(76, 23, 0, 1.0),
                    style: const TextStyle(fontSize: 16,
                      color: Color.fromRGBO(76, 23, 0, 1.0),
                    ),

                  ),
                ),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Среднее время на игру'),
              ),
              TextField(
                controller: gamersController,
                decoration: const InputDecoration(labelText: 'Количество игроков'),
              ),


              TextField(
                controller: rulesController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(labelText: 'Правила игры'),
              ),


              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isFormValid ? _createItem : null,

                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(400, 40),
                    textStyle: const TextStyle(
                      fontSize: 16,
                    )
                ),
                child: const Text('Добавить игру'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
