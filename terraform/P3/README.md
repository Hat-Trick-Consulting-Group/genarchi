# SETUP LAMBDA

3 Steps :

- 1. Create a DynamoDB db, with table name "clients"
- 2. Create a Lambda, "node.18" with correct role and copy past the lamdba func
  - 2.A Use ana parameter specific role
- 3. Call the lamdba in API Gateway, test and deploy
     - 3.A Input passthrough
       `Input passthrough: When there are no templates defined (recommended)`

# CURL examples :

/health

```
 curl -X GET https://26ywp15fia.execute-api.eu-west-3.amazonaws.com/prod/health
```

/add-client

```
curl -X POST https://26ywp15fia.execute-api.eu-west-3.amazonaws.com/prod/add-client -H "Content-Type: application/json" -d '{
  "name": "Joe",
  "email": "joe@epita.fr"
}'
```

# Doc :

For foreign key, we use crypto UUID to get a unique value for each item in the table (builtin js package)

https://stackoverflow.com/questions/37072341/how-to-use-auto-increment-for-primary-key-id-in-dynamodb
