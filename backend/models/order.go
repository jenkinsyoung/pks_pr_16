package models

type Order struct {
	OrderID   int            `db:"order_id" json:"order_id"`
	UserID    string         `db:"user_id" json:"user_id"`
	Total     float64        `db:"total" json:"total"`
	Status    string         `db:"status" json:"status"`
	CreatedAt string         `db:"created_at" json:"created_at"`
	Products  []OrderProduct `json:"products"` // Список товаров в заказе
}

type OrderProduct struct {
	OrderID   int `db:"order_id" json:"order_id"`
	ProductID int `db:"product_id" json:"product_id"`
	Quantity  int `db:"quantity" json:"quantity"`
}
