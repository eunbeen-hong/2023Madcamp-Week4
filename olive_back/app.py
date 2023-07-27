from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials
from flask_cors import CORS
from api_functions import *
import os

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load Firebase credentials
cred = credentials.Certificate(
    "./secret/madcamp4-olive-firebase-adminsdk-9vuqb-693c936edd.json")
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://madcamp4-olive-default-rtdb.asia-southeast1.firebasedatabase.app/',
    'storageBucket': 'gs://madcamp4-olive.appspot.com'
})

# GOOGLE APPLICATION CREDENTIALS
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'secret/madcamp4-olive-fa7204c1d877.json'

# Routes


@app.route('/', methods=['GET'])
def hello_world():
    return 'Hello, World!'


@app.route('/api/remove_book', methods=['DELETE'])
def remove_book_route():
    return remove_book(request)


@app.route('/api/ocr_result', methods=['POST'])
def ocr_result_route():
    return ocr_result(request)


@app.route('/api/send_text_and_image', methods=['POST'])
def send_text_and_image_route():
    return send_text_and_image(request)


@app.route('/api/add_image_and_songs', methods=['POST'])
def add_image_and_songs_route():
    return add_image_and_songs(request)


@app.route('/api/upload_image', methods=['POST'])
def upload_image_route():
    return upload_image(request)


@app.route('/api/send_text', methods=['POST'])
def send_text_route():
    return send_text(request)


@app.route('/api/create_user', methods=['POST'])
def create_user_route():
    return create_user(request)


@app.route('/api/add_category', methods=['POST'])
def add_category_route():
    return add_category(request)


@app.route('/api/create_book', methods=['POST'])
def create_book_route():
    return create_book(request)


@app.route('/api/update_book_access_time', methods=['PUT'])
def update_book_access_time_route():
    return update_book_access_time(request)


@app.route('/api/add_book_to_category', methods=['POST'])
def add_book_to_category_route():
    return add_book_to_category(request)


@app.route('/api/add_song', methods=['POST'])
def add_song_route():
    return add_song(request)


@app.route('/api/remove_book_from_category', methods=['POST'])
def remove_book_from_category_route():
    return remove_book_from_category(request)


@app.route('/api/get_user_info/<string:email>/<string:password>', methods=['GET'])
def get_user_info_route(email, password):
    return get_user_info(email, password)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)


'''
루트 경로에서 아래 세줄 복붙

서버 껐다 킬 때에는 ctrl + c 후 `python3 app.py` 만 다시 하면 됨
'''

'''

cd madcamp4/olive_back
source venv/bin/activate
python3 app.py

'''
