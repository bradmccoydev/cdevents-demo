package main

import (
	"context"

	cdevents "github.com/cdevents/sdk-go/pkg/api"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/sirupsen/logrus"
	log "github.com/sirupsen/logrus"
)

func main() {
	logrus.SetFormatter(&logrus.JSONFormatter{})

	// Create the base event
	event, err := cdevents.NewPipelineRunQueuedEvent()
	if err != nil {
		log.Fatalf("could not create a cdevent, %v", err)
	}

	// Set the required context fields
	event.SetSubjectId("myPipelineRun1")
	event.SetSource("my/first/cdevent/program")

	// Set the required subject fields
	event.SetSubjectPipelineName("myPipeline")
	event.SetSubjectUrl("https://example.com/myPipeline")

	// (...) set the event first
	ce, err := cdevents.AsCloudEvent(event)

	// Set send options
	ctx := cloudevents.ContextWithTarget(context.Background(), "http://localhost:8080/")
	ctx = cloudevents.WithEncodingBinary(ctx)

	c, err := cloudevents.NewClientHTTP()
	if err != nil {
		log.Fatalf("failed to create client, %v", err)
	}

	// Send the CloudEvent
	// c is a CloudEvent client
	if result := c.Send(ctx, *ce); cloudevents.IsUndelivered(result) {
		log.Fatalf("failed to send, %v", result)
	}
}
