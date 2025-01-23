# Flask api for mTLS authentication
![Flask](https://img.shields.io/badge/flask-%23000.svg?style=for-the-badge&logo=flask&logoColor=white)![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

### This repo is a practical implementation to understand how mTLS works


## What is mTLS
Mutual TLS, or mTLS, is a type of mutual authentication in which the two parties in a connection authenticate each other using the TLS protocol. Also, Kubernetes uses this extensively to ensure secure commnucation between different cluster components.

![mtls alt text](/images/mtls.png "How mTLS works")

*Image Source: cloudflare.com*

# Running this project in Docker
```
# git clone https://github.com/arindamgb/flask-mtls-auth 
# cd flask-mtls-auth
# echo '127.0.0.1 api.flaskmtlsauth.com' >> /etc/hosts
# bash cert-generate.sh
# bash run.sh
# docker logs flask-mtls-auth
INFO: *** Client auth is disabled ***
```

# Without mTLS
```
# curl https://api.flaskmtlsauth.com:5001
curl failed to verify the legitimacy of the server and therefore could not establish a secure connection to it.
```

This is because we are using self-signed certificate that is not signed by an actual CA. We can use the **--insecure** or **-k** parameter to avoid this validation.

```
# curl https://api.flaskmtlsauth.com:5001 -k
{"message":"Welcome to the mTLS Flask App!"}
```

Or, we can pass the root certificate of the CA
```
# curl https://api.flaskmtlsauth.com:5001 --cacert pki/ca.crt
{"message":"Welcome to the mTLS Flask App!"}
```
Thus, we have validated the server certificate.

*Please note, the **-k** or **--cacert** option won't be needed if the server certificate is issued by an actual CA like **Digicert**, **Comodo** etc.*

# Enable mTLS and redeploy
```
# sed -i '/^#MTLS_ENABLED=true/s/^#//' .env
# bash run.sh
# docker logs flask-mtls-auth
INFO: *** mTLS is enabled ***
```


# With mTLS
```
# curl https://api.flaskmtlsauth.com:5001 --cacert pki/ca.crt
curl: (56) OpenSSL SSL_read: error:0A00045C:SSL routines::tlsv13 alert certificate required, errno 0
```

This error indicates that the server we are trying to communicate with using curl is requiring a client certificate as part of mutual TLS (mTLS) authentication, but the client (our curl command) has not provided one.
```
# curl https://api.flaskmtlsauth.com:5001 --cacert pki/ca.crt --cert pki/client.crt --key pki/client.key
{"message":"Welcome to the mTLS Flask App!"}
```
Now, we have authenticated ourselves using the client certificate and client key. Again **--cacert** option won't be needed in case of an actual CA.

*Please note, the domain name must be present in the **CN** or **SAN** field defined in the server certificate.*

# Reference

This repo is highly influenced by the Medium article [MTLS-Everything You need to know (Part-I)](https://medium.com/@skshukla.0336/mtls-everything-you-need-to-know-e03804b30804) where Java is used. I also recommend reading this article.


> **Signing off, [Arindam Gustavo Biswas](https://www.linkedin.com/in/arindamgb/)**
>
> 23rd January 2025, 03:10 AM
