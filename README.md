# Start

## For developpement purpose

```
docker compose --env-file ./mongodb/db_config/.env.development up --build
cd frontend
npm run dev
```

Connect to container

```
docker compose --env-file ./mongodb/config/.env.development up --build
docker ps | grep mongo
docker exec -it 86057fb698e3 /bin/bash
mongosh mongodb://user:pass123456@localhost:27017
use genarchi-p2
db.clients.find()
```

## For deployment

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
curl -i -v -X GET http://localhost:3042/health
```

/add-clients

```
curl -X POST -d '{"id": 1, "name": "John Doe", "email": "john@example.com"}' -H "Content-Type: application/json" http://localhost:3042/add-client
```

/get-clients

```
curl -X GET http://localhost:3042/get-clients
```

/update-client

```
curl -X PUT -H "Content-Type: application/json" -d '{"id": "654a4e87f93d1e7bac12cc68", "name":"Maxssssss","email":"ttt@example.com"}' http://localhost:3042/update-client
```

/delete-client

```
curl -X DELETE -H "Content-Type: application/json" -d '{"name":"Maxssssss","email":"ttt@example.com"}' http://localhost:3042/delete-client
```
