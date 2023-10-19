import { DynamoDBClient, ScanCommand } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const dynamoDB = DynamoDBDocument.from(client);
const dynamoDBTableName = "clients";

export const handler = async (event) => {
  const params = {
    TableName: dynamoDBTableName,
  };

  try {
    const command = new ScanCommand(params);
    const result = await dynamoDB.send(command);
    console.log(result);

    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
      },
      body: result.Items,
    };
  } catch (err) {
    console.error("ERROR in Getting Clients: ", err);

    return {
      statusCode: 500, // Change the status code to 500 for internal server error
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        error: "ERROR in Getting Clients",
        message: err.message,
      }),
    };
  }
};
