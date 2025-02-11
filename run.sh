#!/bin/bash
docker rm -f flask-mtls-auth
docker build -t flask-mtls-auth .
docker run -itd --restart=always --name flask-mtls-auth --env-file .env -p 5001:5000 flask-mtls-auth
