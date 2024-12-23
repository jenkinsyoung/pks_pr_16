package models

type Cart struct {
	CartID    int    `db:"cart_id" json:"cart_id"`
	UserID    string `db:"user_id" json:"user_id"`
	ProductID int    `db:"product_id" json:"product_id"`
	Quantity  int    `db:"quantity" json:"quantity"`
	AddedAt   string `db:"added_at" json:"added_at"`
}
