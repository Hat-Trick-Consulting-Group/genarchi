package models

type Client struct {
    // mongo includes an ID field by default
    ID    string    `json:"id"`
    Name  string `json:"name"`
    Email string `json:"email"`
}