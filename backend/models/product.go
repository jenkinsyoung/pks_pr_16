package models

type Product struct {
	ProductID   int     `db:"product_id" json:"product_id"`
	Name        string  `db:"name" json:"name"`
	Description string  `db:"description" json:"description"`
	Rules       string  `db:"rules" json:"rules"`
	Age         int     `db:"age" json:"age"`
	Gamers      string  `db:"gamers" json:"gamers"`
	Time        string  `db:"game_time" json:"game_time"`
	Color       int     `db:"color_ind" json:"color_ind"`
	Price       float64 `db:"price" json:"price"`
	Stock       int     `db:"stock" json:"stock"`
	ImageURL    string  `db:"image" json:"image"`
	CreatedAt   string  `db:"created_at" json:"created_at"`
}
