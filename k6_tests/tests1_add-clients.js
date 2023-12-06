import http from 'k6/http';
import { check, sleep } from 'k6';

export default function () {
  // Get url from command execution
  const url = __ENV.URL;

  //create a random id JSON object
  const payload = {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",    
  };

  console.log(payload);
  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  //Post request
  let res = http.post(url + '/add-client', JSON.stringify(payload), params);
  
  console.log(res.status, res.body);
  //Check response
  check(res, {
    'status is 201': (r) => r.status === 201,
  });
  
  sleep(1);
}

//front http://hat-trick-tf-front-end-bucket.s3-website.eu-west-3.amazonaws.com
//back https://ghc0h59rck.execute-api.eu-west-3.amazonaws.com/prod