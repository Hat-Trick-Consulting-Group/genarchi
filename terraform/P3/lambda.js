import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, PutCommand } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});

const dynamoDB = DynamoDBDocumentClient.from(client);
const dynamoDBTableName = "clients";

// Resources(endpoints) created in API Gateway
const healthPath = "/health";

export const handler = async (event) => {
  console.log("Request event" + event);
  let response;
  switch (true) {
    case event.httpMethod === "GET" && event.path === healthPath:
      response = buildResponse(200);
      break;
    case event.httpMethod === "GET" && event.path === productPath:
      response = await getProduct(event.queryStringParameters.productId);
      break;
    case event.httpMethod === "GET" && event.path === productsPath:
      response = await getProducts();
      break;
    case event.httpMethod === "POST" && event.path === productPath:
      response = await saveProduct(JSON.parse(event.body));
      break;
    case event.httpMethod === "PATCH" && event.path === productPath:
      const requestBody = JSON.parse(event.body);
      response = await modifyProduct(requestBody.productId, requestBody.updateKey, requestBody.updateValue);
      break;
    case event.httpMethod === "DELETE" && event.path === productPath:
      response = await deleteProduct(JSON.parse(event.body).productId);
      break;
    default:
      response = buildResponse(404, "404 Not Found");
  }
  return response;
};

// For specific response structure
function buildResponse(statusCode, body) {
  return {
    statusCode,
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  };
}

// Get Specific Product
async function getProduct(productId) {
  const params = {
    TableName: dynamoDBTableName,
    Key: {
      productId: productId,
    },
  };
  return await dynamoDB
    .get(params)
    .promise()
    .then(
      (response) => {
        return buildResponse(200, response.Item);
      },
      (err) => console.log("ERROR: ", err)
    );
}

// Gets all products
async function getProducts() {
  const params = { TableName: dynamoDBTableName };
  const allProducts = await scanDynamoRecords(params, []);
  const body = {
    products: allProducts,
  };
  return buildResponse(200, body);
}
async function scanDynamoRecords(scanParams, itemArray) {
  try {
    // Read Dynamo DB data, pushing into array
    const dynamoData = await dynamoDB.scan(scanParams).promise();
    itemArray = itemArray.concat(dynamoData.Items);

    if (dynamoData.LastEvaluatedKey) {
      scanParams.ExclusiveStartkey = dynamoData.LastEvaluatedKey;
      return await scanDynamoRecords(scanParams, itemArray);
    }
    return itemArray;
  } catch (err) {
    console.log("ERROR in Scan Dynamo Records: ", err);
  }
}
// Add a Product
async function saveProduct(requestBody) {
  const params = {
    TableName: dynamoDBTableName,
    Item: requestBody,
  };
  return await dynamoDB
    .put(params)
    .promise()
    .then(
      () => {
        const body = {
          Operation: "SAVE",
          Message: "SUCCESS",
          Item: requestBody,
        };
        return buildResponse(200, body);
      },
      (err) => {
        console.log("ERROR in Save Product: ", err);
      }
    );
}
async function modifyProduct(productId, updateKey, updateValue) {
  const params = {
    TableName: dynamoDBTableName,
    Key: {
      productId: productId,
    },
    UpdateExpression: `set ${updateKey} = :value`,
    ExpressionAttributeValues: {
      ":value": updateValue,
    },
    ReturnValues: "UPDATED_NEW",
  };
  return await dynamoDB
    .update(params)
    .promise()
    .then(
      (response) => {
        const body = {
          Operation: "UPDATE",
          Message: "SUCCESS",
          UpdatedAttributes: response,
        };
        return buildResponse(200, body);
      },
      (err) => {
        console.log("ERROR in Update Product: ", err);
      }
    );
}
// Delete a Product
async function deleteProduct(productId) {
  const params = {
    TableName: dynamoDBTableName,
    Key: {
      productId: productId,
    },
    ReturnValues: "ALL_OLD",
  };
  return await dynamoDB
    .delete(params)
    .promise()
    .then(
      (response) => {
        const body = {
          Operation: "DELETE",
          Message: "SUCCESS",
          Item: response,
        };
        return buildResponse(200, body);
      },
      (err) => {
        console.log("ERROR in Delete Product: ", err);
      }
    );
}
