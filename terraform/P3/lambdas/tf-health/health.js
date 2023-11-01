module.exports.handler = async () => {
  const response = {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json",
    },
    body: "ok",
  };
  return response;
};
