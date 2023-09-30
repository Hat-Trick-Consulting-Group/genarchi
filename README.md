# Start

For developpement purpose
Database :

```
docker compose up --build
cd backend
go run main.go
```

For deployment
Backend :

```
cd backend
go build .
./main
```

Frontend :

```
cd frontend
npm run build
```

After use /dist and expose it

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

/update-client

```
curl -X PUT -H "Content-Type: application/json" -d '{"id": 1, "name":"John Doe","email":"johndoe@example.com"}' http://localhost:8080/update-client
```

/delete-client

```
curl -X DELETE -H "Content-Type: application/json" -d '{"name":"John Doe","email":"johndoe@example.com"}' http://localhost:8080/delete-client
```
