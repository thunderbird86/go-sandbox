package main

import (
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"net/http"
)

func main() {
	e := echo.New()

	e.Use(middleware.LoggerWithConfig(middleware.LoggerConfig{
		Format: "time=${time_unix} host=${host} remote_ip=${remote_ip} method=${method}, uri=${uri}, status=${status}\n",
	}))

	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, World!")
	})

	e.GET("/health", getHealth)

	e.Logger.Fatal(e.Start(":1323"))
}

func getHealth(c echo.Context) error {

	return c.String(http.StatusOK, "Hello, World! NEW")
}
