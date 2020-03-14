package main

import (
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
)

type Response struct {
	Message string `json:"message"`
}

func main() {
	r := gin.Default()
	r.GET("/", func(c *gin.Context) {
		log.Println(c.Request.Header)
		c.JSON(http.StatusOK, Response{
			Message: "Hello, World!",
		})
	})
	r.Run(":9000")
}