package handlers

import (
	"database/sql"
	"net/http"
	"shopApi/models"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
)

func GetCart(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("userId")

		if id == "" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректный ID user"})
			return
		}
		var cart []models.Cart
		err := db.Select(&cart, "SELECT * FROM Cart WHERE user_id = $1", id)
		if err != nil {
			if err == sql.ErrNoRows {
				c.JSON(http.StatusNotFound, gin.H{"error": "Корзина пуста"})
			} else {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при запросе корзины"})
			}
			return
		}

		c.JSON(http.StatusOK, cart)
	}
}

func AddToCart(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userId := c.Param("userId")
		var item struct {
			ProductID int `json:"product_id"`
			Quantity  int `json:"quantity"`
		}
		if err := c.ShouldBindJSON(&item); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректные данные"})
			return
		}
		_, err := db.Exec("INSERT INTO Cart (user_id, product_id, quantity) VALUES ($1, $2, $3) ON CONFLICT (user_id, product_id) DO UPDATE SET quantity = $3",
			userId, item.ProductID, item.Quantity)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка добавления в корзину", "details": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Товар добавлен в корзину"})
	}
}

func RemoveFromCart(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userId := c.Param("userId")
		productId := c.Param("productId")
		_, err := db.Exec("DELETE FROM Cart WHERE user_id = $1 AND product_id = $2", userId, productId)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка удаления из корзины"})
			return
		}
		c.JSON(http.StatusOK, gin.H{"message": "Товар удален из корзины"})
	}
}
