import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});

const dynamoDB = DynamoDBDocumentClient.from(client);
const dynamoDBTableName = "clients";

export const handler = async (event) => {
  const params = {
    TableName: dynamoDBTableName,
  };

  return await dynamoDB.scan(params).then(
    (items) => {
      console.log(items);
      return {
        statusCode: 201,
        headers: {
          "Content-Type": "application/json",
        },
        body: items,
      };
    },
    (err) => {
      console.log("ERROR in Getting Clients: ", err);
      return {
        statusCode: 404,
        headers: {
          "Content-Type": "application/json",
        },
        body: "ERROR in Getting Clients: " + JSON.stringify(err),
      };
    }
  );
};
