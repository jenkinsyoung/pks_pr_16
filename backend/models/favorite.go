package models

type Favorite struct {
	FavoriteID int    `db:"favorite_id" json:"favorite_id"`
	UserID     string `db:"user_id" json:"user_id"`
	ProductID  int    `db:"product_id" json:"product_id"`
	AddedAt    string `db:"added_at" json:"added_at"`
}
