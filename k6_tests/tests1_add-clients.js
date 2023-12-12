import http from 'k6/http';
import { check, sleep } from 'k6';

export default function () {
  // Get url from command execution
  const url = __ENV.URL;

  //create a random id JSON object
  const payload = {
    "name": "John Doe",
    "email": "john@example.com",    
  };

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  //Post request
  let res = http.post(url + '/add-client', JSON.stringify(payload), params);
  
  //Check response
  check(res, {
    'status is 201': (r) => r.status === 201,
  });
}