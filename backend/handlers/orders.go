package handlers

import (
	"log"
	"net/http"
	"shopApi/models"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
	"github.com/lib/pq"
)

func GetOrders(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		// Получаем ID пользователя из параметра маршрута
		id := c.Param("user_id")
		log.Println("Полученный параметр:", id)

		// Преобразуем строковый ID в целое число
		if id == "" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректный ID user"})
			return
		}

		// Выполняем запрос для получения заказов
		var orders []models.Order
		orderQuery := `
			SELECT order_id, user_id, total, status, created_at
			FROM orders
			WHERE user_id = $1
		`
		err := db.Select(&orders, orderQuery, id)
		if err != nil {
			log.Println("Ошибка запроса заказов:", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка получения заказов"})
			return
		}

		// Если нет заказов, возвращаем пустой массив
		if len(orders) == 0 {
			c.JSON(http.StatusOK, []models.Order{})
			return
		}

		// Получаем список order_id для выборки товаров
		orderIDs := make([]int, len(orders))
		for i, order := range orders {
			orderIDs[i] = order.OrderID
		}

		// Выполняем запрос для получения товаров по заказам
		var products []models.OrderProduct
		productsQuery := `
			SELECT order_id, product_id, quantity
			FROM order_items
			WHERE order_id = ANY($1)
		`
		err = db.Select(&products, productsQuery, pq.Array(orderIDs))
		if err != nil {
			log.Println("Ошибка запроса товаров:", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка получения товаров для заказов"})
			return
		}

		// Создаем мапу товаров по order_id
		productMap := make(map[int][]models.OrderProduct)
		for _, product := range products {
			productMap[product.OrderID] = append(productMap[product.OrderID], product)
		}

		// Привязываем товары к соответствующим заказам
		for i, order := range orders {
			orders[i].Products = productMap[order.OrderID]
		}

		// Отправляем результат
		c.JSON(http.StatusOK, orders)
	}
}

func CreateOrder(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var order models.Order

		// Привязываем данные из тела запроса
		if err := c.ShouldBindJSON(&order); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректные данные"})
			log.Printf("Error binding JSON: %v", err)
			return
		}

		// Проверка на пустую коллекцию продуктов
		if len(order.Products) == 0 {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Список товаров не может быть пустым"})
			log.Println("Error: empty product list")
			return
		}

		// Вставляем заказ в таблицу orders
		queryOrder := `
            INSERT INTO orders (user_id, total, status)
            VALUES (:user_id, :total, :status)
            RETURNING order_id
        `

		rows, err := db.NamedQuery(queryOrder, order)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка добавления заказа"})
			log.Printf("Error inserting order: %v", err)
			return
		}
		defer rows.Close()

		// Получаем ID нового заказа
		if rows.Next() {
			if err := rows.Scan(&order.OrderID); err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка получения ID заказа"})
				log.Printf("Error scanning order_id: %v", err)
				return
			}
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Не удалось получить ID заказа"})
			log.Println("Error: no rows returned from order insert query")
			return
		}

		// Вставляем товары в таблицу order_items
		queryProducts := `
            INSERT INTO order_items (order_id, product_id, quantity)
            VALUES (:order_id, :product_id, :quantity)
        `

		for _, product := range order.Products {
			log.Printf("Inserting product: order_id=%d, product_id=%d, quantity=%d", order.OrderID, product.ProductID, product.Quantity)

			if product.ProductID <= 0 || product.Quantity <= 0 {
				log.Printf("Invalid product data: %v", product)
				continue
			}

			productData := map[string]interface{}{
				"order_id":   order.OrderID,
				"product_id": product.ProductID,
				"quantity":   product.Quantity,
			}

			// Выполнение запроса
			_, err := db.NamedExec(queryProducts, productData)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка добавления товара в заказ", "details": err.Error()})
				log.Printf("Error inserting product: %v", err)
				return
			}
		}

		// Отправляем успешный ответ с ID заказа
		c.JSON(http.StatusCreated, gin.H{"order_id": order.OrderID})
	}
}
