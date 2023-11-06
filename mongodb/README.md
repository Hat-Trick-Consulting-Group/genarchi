# Launch MongoDB

Connect to container

```
docker compose --env-file ./config/.env.development up --build
docker ps | grep mongo
docker exec -it 86057fb698e3 /bin/bash
mongosh
use admin
```
