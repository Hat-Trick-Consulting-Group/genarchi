import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, PutCommand } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});

const dynamoDB = DynamoDBDocumentClient.from(client);
const dynamoDBTableName = "clients";

// Resources(endpoints) created in API Gateway
const healthPath = "/health";

export const handler = async (event) => {
  const response = {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json",
    },
    body: "ok",
  };
  return response;
};
