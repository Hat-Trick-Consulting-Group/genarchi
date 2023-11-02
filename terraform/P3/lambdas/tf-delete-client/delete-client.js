import { DynamoDBClient, DeleteItemCommand } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const dynamoDB = DynamoDBDocument.from(client);
const dynamoDBTableName = "clients";

export const handler = async (event) => {
  const { id } = event;

  const params = {
    TableName: dynamoDBTableName,
    Key: {
      id: {
        S: id,
      },
    },
  };

  try {
    const res = await dynamoDB.send(new DeleteItemCommand(params));

    return {
      statusCode: 204,
      headers: {
        "Content-Type": "application/json",
      },
      body: { message: "Client deleted successfully", id: id },
    };
  } catch (err) {
    return {
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
      },
      body: {
        error: "ERROR in Delete Client",
        message: err.message,
      },
    };
  }
};
