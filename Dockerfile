FROM golang:alpine AS build

RUN apk add --no-cache gcc libc-dev git

WORKDIR /src/cdevents-demo

# Force the go compiler to use modules
ENV GO111MODULE=on
ENV BUILDFLAGS=""
ENV GOPROXY=https://proxy.golang.org

# Copy `go.mod` for definitions and `go.sum` to invalidate the next layer
# in case of a change in the dependencies
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

ARG debugBuild

# set buildflags for debug build
RUN if [ ! -z "$debugBuild" ]; then export BUILDFLAGS='-gcflags "all=-N -l"'; fi

# Copy local code to the container image.
COPY . .

# Build the command inside the container.
# (You may fetch or manage dependencies here, either manually or with a tool like "godep".)
RUN GOOS=linux go build -ldflags '-linkmode=external' $BUILDFLAGS -v -o cdevents-demo

RUN go build -o /cdevents-demo

FROM alpine:latest

RUN    apk update && apk upgrade \
	&& apk add ca-certificates libc6-compat \
	&& update-ca-certificates \
	&& rm -rf /var/cache/apk/*

COPY --from=build /src/cdevents-demo/cdevents-demo /cdevents-demo
RUN echo ls
EXPOSE 80

# required for external tools to detect this as a go binary
ENV GOTRACEBACK=all

ENTRYPOINT [ "./cdevents-demo" ]
