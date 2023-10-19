import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, PutCommand } from "@aws-sdk/lib-dynamodb";
import { randomUUID } from "crypto";

const client = new DynamoDBClient({});

const dynamoDB = DynamoDBDocumentClient.from(client);
const dynamoDBTableName = "clients";

// Resources(endpoints) created in API Gateway
const healthPath = "/add-client";

export const handler = async (event) => {
  const params = {
    TableName: dynamoDBTableName,
    Item: {
      id: randomUUID(),
      name: event.name,
      email: event.email,
    },
  };

  return await dynamoDB.send(new PutCommand(params)).then(
    () => {
      console.log("Added item to DynamoDB");
      return {
        statusCode: 201,
        headers: {
          "Content-Type": "application/json",
        },
        body: params,
      };
    },
    (err) => {
      console.log("ERROR in Save Product: ", err);
      return {
        statusCode: 404,
        headers: {
          "Content-Type": "application/json",
        },
        body: "ERROR in Save Product: " + JSON.stringify(err),
      };
    }
  );
};
