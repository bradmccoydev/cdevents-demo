package main

import (
	"net/http"

	"github.com/bradmccoydev/cdevents-demo/handlers"
	"github.com/sirupsen/logrus"
	log "github.com/sirupsen/logrus"
)

func handleRequests() {
	logrus.SetFormatter(&logrus.JSONFormatter{})

	router := handlers.Router()
	log.Print("The service is ready to listen and serve.")
	log.Fatal(http.ListenAndServe(":80", router))
}

func main() {
	handleRequests()
}
