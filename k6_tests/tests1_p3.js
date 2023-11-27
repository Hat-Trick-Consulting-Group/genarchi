import http from 'k6/http';
import { sleep } from 'k6';

export default function () {
  http.get('https://jz4dtb6gzg.execute-api.eu-west-3.amazonaws.com/prod/health');
  sleep(1);
}