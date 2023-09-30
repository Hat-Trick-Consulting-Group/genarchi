# Start

Database :

```
docker compose up --build
```

Backend :

```
cd backend
go build .
./main
```

# Routes

/health

```
curl -i -v -X GET http://localhost:8080/health
```

/add-clients

```
curl -X POST -H "Content-Type: application/json" -d '{"name":"John Doe","email":"johndoe@example.com"}' http://localhost:8080/add-client
```

/get-clients

```
curl -X GET http://localhost:8080/get-clients
```
