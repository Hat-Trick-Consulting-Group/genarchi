import { DynamoDBClient, DeleteItemCommand } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const dynamoDB = DynamoDBDocument.from(client);
const dynamoDBTableName = "clients";

export const handler = async (event) => {
  if (event?.body) {
    event = JSON.parse(event.body);
  }
  const { id } = event;

  const params = {
    TableName: dynamoDBTableName,
    Key: {
      id: {
        S: id,
      },
    },
  };

  return await dynamoDB.send(new DeleteItemCommand(params)).then(
    () => {
      const response = { message: "Client deleted successfully", id: id };

      return {
        statusCode: 204,
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(response),
      };
    },
    (err) => {
      return {
        statusCode: 404,
        headers: {
          "Content-Type": "application/json",
        },
        body: "ERROR in Delete Client: " + JSON.stringify(err),
      };
    }
  );
};
