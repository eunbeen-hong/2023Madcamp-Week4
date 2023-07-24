# app.py

import os
from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, db, auth
from flask_cors import CORS

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load Firebase credentials
cred = credentials.Certificate(
    "./secret/madcamp4-olive-firebase-adminsdk-9vuqb-40f59b3716.json")
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://madcamp4-olive-default-rtdb.asia-southeast1.firebasedatabase.app/'
})

# Routes


@app.route('/')
def hello_world():
    return 'Hello, World!'


@app.route('/api/send_text_and_image', methods=['POST'])
def send_text_and_image():
    try:
        data = request.json
        text = data.get('text')
        image = data.get('image')
        if text and image:
            # Handle text and image processing here
            # For example, you can save the image to a file or database
            # and perform any additional text processing required
            # Return some response indicating success
            return jsonify({'message': 'Text and image received and processed successfully!'})
        else:
            return jsonify({'error': 'Missing text or image data.'})
    except Exception as e:
        return jsonify({'error': str(e)})


@app.route('/api/upload_image', methods=['POST'])
def upload_image():
    # Handle image upload and processing here
    # Return some response indicating success
    return jsonify({'message': 'Image received and processed successfully!'})


@app.route('/api/send_text', methods=['POST'])
def send_text():
    try:
        data = request.json
        text = data.get('text')
        if text:
            print('Received text:', text)
            # Handle text processing here
            # Return some response indicating success
            return jsonify({'message': 'Text received and processed successfully!'})
        else:
            return jsonify({'error': 'No text data received.'})
    except Exception as e:
        return jsonify({'error': str(e)})


if __name__ == '__main__':
    app.run(port=3000)
