package handlers

import (
	"database/sql"
	"net/http"
	"shopApi/models"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
)

func GetFavorites(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("userId")

		if id == "" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректный ID user"})
			return
		}
		var favorite []models.Favorite
		err := db.Select(&favorite, "SELECT * FROM Favorites WHERE user_id = $1 ORDER BY product_id ASC", id)
		if err != nil {
			if err == sql.ErrNoRows {
				c.JSON(http.StatusNotFound, gin.H{"error": "Нет избранных игр"})
			} else {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при запросе избранного"})
			}
			return
		}

		c.JSON(http.StatusOK, favorite)
	}
}
func AddToFavorites(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userId := c.Param("userId")
		var item struct {
			ProductID int `json:"product_id"`
		}
		if err := c.ShouldBindJSON(&item); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректные данные"})
			return
		}
		_, err := db.Exec("INSERT INTO Favorites (user_id, product_id) VALUES ($1, $2) ON CONFLICT DO NOTHING",
			userId, item.ProductID)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка добавления в избранное"})
			return
		}
		c.JSON(http.StatusOK, gin.H{"message": "Товар добавлен в избранное"})
	}
}

func RemoveFromFavorites(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userId := c.Param("userId")
		productId := c.Param("productId")
		_, err := db.Exec("DELETE FROM Favorites WHERE user_id = $1 AND product_id = $2", userId, productId)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка удаления из избранного"})
			return
		}
		c.JSON(http.StatusOK, gin.H{"message": "Товар удален из избранного"})
	}
}

func IsFavorite(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userId := c.Param("userId")
		productId := c.Param("productId")

		var exists bool
		err := db.Get(&exists, "SELECT EXISTS(SELECT 1 FROM Favorites WHERE user_id = $1 AND product_id = $2)", userId, productId)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка проверки избранного"})
			return
		}
		if exists {
			c.JSON(http.StatusOK, gin.H{"isFavorite": true})
		} else {
			c.JSON(http.StatusNotFound, gin.H{"isFavorite": false})
		}
	}
}
