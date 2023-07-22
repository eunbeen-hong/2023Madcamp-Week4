# app.py

import os
from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, db, auth

# Initialize Flask app
app = Flask(__name__)

# Load Firebase credentials
cred = credentials.Certificate("./secret/madcamp4-olive-firebase-adminsdk-9vuqb-40f59b3716.json")
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://madcamp4-olive-default-rtdb.asia-southeast1.firebasedatabase.app/'
})

# Routes
@app.route('/')
def hello_world():
    return 'Hello, World!'

# Sample protected route - requires authentication
@app.route('/protected')
def protected_route():
    # Verify Firebase ID token
    auth_header = request.headers.get('Authorization')
    
    if not auth_header or not auth_header.startswith('Bearer '):
        return jsonify({'error': 'Invalid or missing Authorization header.'}), 401

    id_token = auth_header.split('Bearer ')[1]

    try:
        decoded_token = auth.verify_id_token(id_token)
        # You can access user information from decoded_token, e.g., decoded_token['uid']
        return jsonify({'message': 'Authenticated successfully!'})
    except auth.InvalidIdTokenError:
        return jsonify({'error': 'Invalid ID token.'}), 401
    except auth.ExpiredIdTokenError:
        return jsonify({'error': 'Expired ID token.'}), 401

if __name__ == '__main__':
    app.run()
