# K6

----------
## Tutorials: How to K6

1) write a .js script with your tests (you can take a look at the exiting one)
2) run 
```
k6 run --vus XX --duration XXs your_script.js --env URL="yourURL"
```
Replace XX by positives integers and yourURL with the backend-api url (keep the quotes)

vus being "virtual users" (parallels "while true" execution of the script)
durations being the duration of the script being executed in seconds

----------
## Official Documentation
Installation: https://k6.io/docs/get-started/installation/
How to run: https://k6.io/docs/get-started/running-k6/