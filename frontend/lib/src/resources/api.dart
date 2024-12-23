import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pr_12/src/models/basket_model.dart';
import 'package:pr_12/src/models/favorite_model.dart';
import 'package:pr_12/src/models/game_model.dart';
import 'package:pr_12/src/models/order_model.dart';
import 'package:pr_12/src/models/user_model.dart';

const url = '10.0.2.2:8080';
class ApiService {
  final Dio _dio = Dio();
// Метод для получения списка всех товаров
  Future<List<Game>> getProducts() async {
    try {
      final response = await _dio.get('http://$url/products');
      if (response.statusCode == 200) {
        List<Game> games = (response.data as List)
            .map((game) => Game.fromJson(game))
            .toList();

        return games;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
// Метод для получения товара по ID
  Future<Game> getProductById(int gameId) async {
    try {
      final response = await _dio.get('http://$url/products/$gameId');
      if (response.statusCode == 200) {
        return Game.fromJson(response.data);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Метод для добавления нового товара
  Future<void> addProduct(Game item) async {
    try {
      final response = await _dio.post(
        'http://$url/products',
        data: item.toJson(),
      );
      print(item.toJson().toString());
      if (response.statusCode == 201) {
        print('Product added successfully');
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  // Удаление товара
  Future<void> deleteProduct(int id) async {
    try {
      final response = await _dio.delete(
        'http://$url/products/$id',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete item');
      }
    } catch (e) {
      throw Exception('Error deleting item: $e');
    }
  }

  // Обновление информации о продукте
  Future<void> updateGameInfo(int id, Game item) async {
    try {
      final response = await _dio.put(
        'http://$url/products/$id',
        data: item.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update information');
      }
    } catch (e) {
      throw Exception('Error updating information: $e');
    }
  }
// Получение данных пользователя
  Future<UserFromDB> getUser(String id) async {

    try {
      final response = await _dio.get('http://$url/user/$id');

      if (response.statusCode == 200) {
        return UserFromDB.fromJson(response.data);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
  // Добавление пользователя
  Future<void> addUser(UserFromDB user) async {
    try {
      final response = await _dio.post(
        'http://$url/register',
        data: {
          "user_id": user.userId,
          "email": user.email
      },
      );
      if (response.statusCode == 201) {
        print('User added successfully');
      } else {
        throw Exception('Failed to add user');
      }
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }
// Получение элементов в корзине
  Future<List<BasketItem>> getBasket(String userId) async {
    try {
      final response = await _dio.get('http://$url/cart/$userId');
      if (response.statusCode == 200) {
        print("Basket Response: ${response.data}");
        List<BasketItem> basket = (response.data as List)
            .map((item) => BasketItem.fromJson(item))
            .toList();

        return basket;
      } else {
        throw Exception('Failed to load basket');
      }
    } catch (e) {
      throw Exception('Error fetching basket: $e');
    }
  }

  // Добавление товара в корзину
  Future<void> addToBasket(int gameId, int counter, String userId) async {
    await _dio.post('http://$url/cart/$userId', data: {"product_id": gameId, "quantity": counter});

  }

  Future<void> clearBasket(List<BasketItem> basketItems, String userId) async {
    for (var item in basketItems) {
      await removeFromBasket(item.gameId, userId);
    }
  }
  // Удаление товара из корзины
  Future<void> removeFromBasket(int gameId, String userId) async {
    await _dio.delete('http://$url/cart/$userId/$gameId');
  }

  // Получение избранных игр пользователя
  Future<List<Favorite>> getFavorites(String userId) async {
    try {
      final response = await _dio.get('http://$url/favorites/$userId');
      if (response.statusCode == 200) {
        print("Basket Response: ${response.data}");
        List<Favorite> favorites = (response.data as List)
            .map((item) => Favorite.fromJson(item))
            .toList();

        return favorites;
      } else {
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      throw Exception('Error fetching favorites: $e');
    }
  }
  // Добавление игры в "Избранное"
  Future<void> addToFavorites(int gameId, String userId) async {
    await _dio.post('http://$url/favorites/$userId', data: {"product_id": gameId});
  }
  // Удаление игры из "Избранного"
  Future<void> removeFromFavorites(int gameId, String userId) async {
    await _dio.delete('http://$url/favorites/$userId/$gameId');
  }

  // Получение заказов пользователя
  Future<List<Order>> getOrders(String userId) async {
    try {
      final response = await _dio.get('http://$url/orders/$userId');
      if (response.statusCode == 200) {
        List<Order> orders = (response.data as List)
            .map((order) => Order.fromJson(order))
            .toList();

        return orders;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
    throw Exception('Error fetching orders: $e');
    }
  }
  // Добавление заказа пользователя
  Future<void> createOrder(List<BasketItem> cartData, double total, String userId) async {

    const status = 'Ожидает оплаты';

    final orderData = {
      "user_id": userId,
      "status": status,
      "total": total,
      "products": cartData.map((item) {
        return {
          "product_id": item.gameId,
          "quantity": item.counter,
        };
      }).toList(),
    };
    print(orderData);
    try {
      final response = await _dio.post(
        'http://$url/orders/$userId',
        data: orderData,
      );

      if (response.statusCode == 201) {
        print('Order created successfully: ${response.data}');
      } else {
        print('Failed to create order: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}