import { DynamoDBClient, UpdateItemCommand } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const dynamoDB = DynamoDBDocument.from(client);
const dynamoDBTableName = "clients";

export const handler = async (event) => {
  if (event?.body) {
    event = JSON.parse(event.body);
  }
  const { id, name, email } = event;

  const params = {
    TableName: dynamoDBTableName,
    Key: {
      id: { S: id }, // Assuming id is a string, adjust the type accordingly
    },
    UpdateExpression: "SET #name = :name, #email = :email",
    ExpressionAttributeNames: {
      "#name": "name",
      "#email": "email",
    },
    ExpressionAttributeValues: {
      ":name": { S: name }, // Assuming name is a string, adjust the type accordingly
      ":email": { S: email }, // Assuming email is a string, adjust the type accordingly
    },
    ReturnValues: "ALL_NEW", // Change this based on your needs
  };

  try {
    const result = await dynamoDB.send(new UpdateItemCommand(params));

    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(result),
    };
  } catch (err) {
    return {
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
      },
      body: {
        error: "ERROR in Update Client",
        message: err.message,
      },
    };
  }
};
