FROM golang:1.18

WORKDIR /usr/src/app

COPY . .
# Run go mod tidy to ensure dependencies are up to date
RUN go mod tidy

# Build your Go application
RUN go build -o api-app

# Expose the port your application will listen on
EXPOSE 8080

# Start your application using the compiled binary
CMD ["./api-app", "-b", "0.0.0.0"]