package models

import "database/sql"

type User struct {
	UserId    string         `db:"user_id" json:"user_id"`
	Username  sql.NullString `db:"username" json:"username"`
	Email     string         `db:"email" json:"email"`
	Password  sql.NullString `db:"password_hash" json:"password_hash"`
	ImageURL  sql.NullString `db:"image" json:"image"`
	CreatedAt string         `db:"created_at" json:"created_at"`
	Phone     sql.NullString `db:"phone" json:"phone"`
	Role      string         `db:"role" json:"role"`
}
