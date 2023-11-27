# K6

----------
## Tutorials: How to K6

1) write a .js script with your tests
2) run 
```
k6 run --vus XX --duration XXs your_script.js
```

vus being "vitual users" (parrallels "while true" execution of the script)
durations being the duration of the script being executed in seconds

----------
## Official Documentation
Installation: https://k6.io/docs/get-started/installation/
How to run: https://k6.io/docs/get-started/running-k6/