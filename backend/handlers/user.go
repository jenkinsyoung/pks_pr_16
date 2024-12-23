package handlers

import (
	"database/sql"
	"net/http"
	"shopApi/models"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
)

func GetUser(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("userId")

		if id == "" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректный ID пользователя"})
			return
		}

		var user models.User

		err := db.Get(&user, "SELECT * FROM Users WHERE user_id = $1", id)

		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "Пользователь не найден"})
			return
		}

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при запросе к базе данных", "details": err.Error()})
			return
		}

		c.JSON(http.StatusOK, user)
	}
}

func UpdateUser(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("userId")
		if id == "" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректный ID пользователя"})
			return
		}

		var user models.User
		if err := c.ShouldBindJSON(&user); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректные данные"})
			return
		}

		var username interface{}
		if user.Username.Valid {
			username = user.Username.String
		} else {
			username = nil
		}

		var image interface{}
		if user.ImageURL.Valid {
			image = user.ImageURL.String
		} else {
			image = nil
		}

		var phone interface{}
		if user.Phone.Valid {
			phone = user.Phone.String
		} else {
			phone = nil
		}

		query := `UPDATE Users 
		          SET username = :username, image = :image, phone = :phone
		          WHERE user_id = :user_id`

		_, err := db.NamedExec(query, map[string]interface{}{
			"user_id":  id,
			"username": username,
			"image":    image,
			"phone":    phone,
		})
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка обновления пользователя"})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Пользователь успешно обновлен"})
	}
}

func CreateUser(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var user models.User
		if err := c.ShouldBindJSON(&user); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректные данные"})
			return
		}

		query := `INSERT INTO Users (user_id, email)
				  VALUES (:user_id, :email) RETURNING user_id`

		rows, err := db.NamedQuery(query, &user)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка добавления пользователя"})
			return
		}
		if rows.Next() {
			rows.Scan(&user.UserId)
		}
		rows.Close()

		c.JSON(http.StatusCreated, user)
	}
}
