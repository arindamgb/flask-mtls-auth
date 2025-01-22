#!/bin/bash

# Generate CA certs
openssl genrsa -out pki/ca.key 2048
openssl req -x509 -new -nodes -key pki/ca.key -sha256 -days 365 -out pki/ca.crt -subj "/C=BD/ST=Dhaka/L=Dhaka/O=ARINDAMGB/OU=MTLS-CA/CN=certificate-authority"

# Generate Server certs
openssl genrsa -out pki/server.key 2048
openssl req -new -key pki/server.key -out pki/server.csr -subj "/C=BD/ST=Dhaka/L=Dhaka/O=ARINDAMGB/OU=MTLS-SERVER/CN=*.flaskmtlsauth.com"
openssl x509 -req -in pki/server.csr -CA pki/ca.crt -CAkey pki/ca.key -CAcreateserial -out pki/server.crt -days 365 -sha256

# Generate Client certs
openssl genrsa -out pki/client.key 2048
openssl req -new -key pki/client.key -out pki/client.csr -subj "/C=BD/ST=Dhaka/L=Dhaka/O=ARINDAMGB/OU=MTLS-CLIENT/CN=*.flaskmtlsauth.com"
openssl x509 -req -in pki/client.csr -CA pki/ca.crt -CAkey pki/ca.key -CAcreateserial -out pki/client.crt -days 365 -sha256
