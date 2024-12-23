import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final Map<String, dynamic> currentFilters;

  const FilterDialog({required this.currentFilters, super.key});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.currentFilters.containsKey('price')) {
      _minPriceController.text = widget.currentFilters['price'][0].toString();
      _maxPriceController.text = widget.currentFilters['price'][1].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Фильтры по цене'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _minPriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Минимальная цена',
              hintText: 'Введите минимальную цену',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _maxPriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Максимальная цена',
              hintText: 'Введите максимальную цену',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final minPrice = int.tryParse(_minPriceController.text);
            final maxPrice = int.tryParse(_maxPriceController.text);

            if (minPrice != null && maxPrice != null) {
              final newFilters = {
                'price': [minPrice, maxPrice],
              };
              Navigator.of(context).pop(newFilters);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Пожалуйста, введите корректные значения цен')),
              );
            }
          },
          child: const Text('Применить'),
        ),
      ],
    );
  }
}

