# SETUP LAMBDA

3 Steps :

- 1. Create a DynamoDB db, with table name "clients"
- 2. Create a Lambda, "node.18" with correct role and copy past the lamdba func
- 3. Call the lamdba in API Gateway, test and deploy
     - 3.A Input passthrough
       `Input passthrough: When there are no templates defined (recommended)`
