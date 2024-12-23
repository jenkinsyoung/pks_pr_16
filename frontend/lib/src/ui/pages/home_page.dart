import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr_12/src/models/game_model.dart';
import 'package:pr_12/src/models/user_model.dart';
import 'package:pr_12/src/resources/api.dart';
import 'package:pr_12/src/resources/search_func/filter.dart';
import 'package:pr_12/src/resources/search_func/search.dart';
import 'package:pr_12/src/resources/search_func/sort.dart';
import 'package:pr_12/src/ui/components/filter_dialog.dart';
import 'package:pr_12/src/ui/components/game_card.dart';
import 'package:pr_12/src/ui/pages/add_page.dart';
import 'package:pr_12/src/ui/pages/info_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Game>> _games;
  List<Game> filteredGames = [];
  String searchQuery = "";
  Map<String, dynamic> filters = {};
  int _sortOption = 0;


  @override
  void initState() {
    super.initState();
    _games = ApiService().getProducts();
    _games.then((data) {
      setState(() {
        filteredGames = data;
      });
    });

  }

  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      _applyFiltersAndSearch();
    });
  }

  void _updateFilters(Map<String, dynamic> newFilters) {
    setState(() {
      filters = newFilters;
      _applyFiltersAndSearch();
    });
  }

  void _applyFiltersAndSearch() {
    _games.then((games) {
      List<Game> results = search(games, searchQuery);

      if (filters.isNotEmpty && filters.containsKey('price')) {
        results = filter(results, filters['price'][0], filters['price'][1]);
      }
      results = sort(results, _sortOption);
      setState(() {
        filteredGames = results;
      });
    });
  }
  void _addGame(Game game) {
    setState(() {
      ApiService().addProduct(game);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Настольные игры',
            style: TextStyle(
              color: Color.fromRGBO(76, 23, 0, 1.0),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _updateSearchQuery,
                    decoration: const InputDecoration(
                      hintText: 'Поиск игр...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: DropdownButton<int>(
                  value: _sortOption,
                  icon: const Icon(Icons.sort),
                  onChanged: (int? newValue) {
                    setState(() {
                      _sortOption = newValue!;
                      _applyFiltersAndSearch();
                    });
                  },
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Без сортировки')),
                    DropdownMenuItem(value: 1, child: Text('От А до Я')),
                    DropdownMenuItem(value: 2, child: Text('От Я до А')),
                    DropdownMenuItem(value: 3, child: Text('По возрастанию цены')),
                    DropdownMenuItem(value: 4, child: Text('По убыванию цены')),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    filters = {};
                    _applyFiltersAndSearch();
                  });
                },
                child: const Text(
                  'Сбросить',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () async {
                  final newFilters = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (context) => FilterDialog(currentFilters: filters),
                  );
                  if (newFilters != null) {
                    _updateFilters(newFilters);
                  }
                },
              ),

            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: _games,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (filteredGames.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Нет доступных товаров, добавьте хотя бы одну карточку',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(76, 23, 0, 1.0),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          childAspectRatio: 161 / 205,
                        ),
                        itemCount: filteredGames.length,
                        itemBuilder: (context, index) {
                          final game = filteredGames[index];
                          return GestureDetector(
                            onTap: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => InfoPage(gameId: game.id),
                                ),
                              );
                              if (result != null && result is Game) {
                                setState(() {
                                  filteredGames[index] = result;
                                });
                              }
                            },
                            child: GameCard(
                              game: game,
                              bodyColor: game.colorInd == 1
                                  ? const Color.fromRGBO(255, 207, 2, 1.0)
                                  : game.colorInd == 2
                                  ? const Color.fromRGBO(163, 3, 99, 1.0)
                                  : const Color.fromRGBO(48, 0, 155, 1.0),
                              textColor: game.colorInd == 1
                                  ? const Color.fromRGBO(129, 40, 0, 1.0)
                                  : game.colorInd == 2
                                  ? const Color.fromRGBO(255, 204, 254, 1.0)
                                  : const Color.fromRGBO(203, 238, 251, 1.0),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
        floatingActionButton:
      FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );
          if (result != null && result is Game) {
            _addGame(result);
          }
        },
        backgroundColor: const Color.fromRGBO(76, 23, 0, 1.0),
        foregroundColor: const Color.fromRGBO(255, 230, 230, 1.0),
        child: const Icon(Icons.add),
      ),
    );
  }
}
