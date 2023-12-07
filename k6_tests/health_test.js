import http from 'k6/http';
import { check, sleep } from 'k6';

export default function () {
  // Get url from command execution
  const url = __ENV.URL;

  //Get request
  let res = http.get(url + '/health');
  
  //Check response
  check(res, {
    'status is 200': (r) => r.status === 200,
  });
}