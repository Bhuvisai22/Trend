#!/bin/bash
docker stop trend-app || true
docker rm trend-app || true
docker run -d -p 80:80 --name trend-app saidoc540/trend-app:latest
