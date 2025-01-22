from flask import Flask, jsonify
import os
import ssl
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)

# Load configuration from environment variables
SSL_CERT_FILE = os.getenv("SSL_CERT_FILE")
SSL_KEY_FILE = os.getenv("SSL_KEY_FILE")
SSL_CA_FILE = os.getenv("SSL_CA_FILE")
MTLS_ENABLED = os.getenv("MTLS_ENABLED", "false").lower() == "true"

@app.route('/')
def index():
    return jsonify({"message": "Welcome to the mTLS Flask App!"})

if __name__ == '__main__':
    context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)

    # Load server certificate and key
    context.load_cert_chain(certfile=SSL_CERT_FILE, keyfile=SSL_KEY_FILE)

    if MTLS_ENABLED:
        print("INFO: *** mTLS is enabled ***")
        context.verify_mode = ssl.CERT_REQUIRED
        context.load_verify_locations(cafile=SSL_CA_FILE)
    else:
        print("INFO: *** Client auth is disabled ***")

    app.run(host='0.0.0.0', port=5000, ssl_context=context)
