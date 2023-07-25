from flask import request, jsonify
import firebase_admin
from firebase_admin import db, auth
from google.cloud import storage
import datetime


def send_text_and_image(request):
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


def upload_image(request):
    # Assuming you receive the image data in the request
    image_data = request.get_json().get('image')

    # Initialize Firebase Admin SDK (if not already initialized)
    if not firebase_admin._apps:
        cred = credentials.Certificate(
            './secret/madcamp4-olive-firebase-adminsdk-9vuqb-40f59b3716.json')
        firebase_admin.initialize_app(cred, {
            'storageBucket': 'madcamp4-olive.appspot.com'
        })

    # Create a unique filename for the image (you can use any method to generate a unique name)
    filename = 'image.jpg'

    # Upload the image data to Firebase Storage
    bucket = storage.bucket()
    blob = bucket.blob(filename)
    blob.upload_from_string(image_data, content_type='image/jpeg')

    # Get the public URL of the uploaded image
    url = blob.public_url

    # Return the URL to the client or any other response you want
    return jsonify({'url': url})


def send_text(request):
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


def create_user(request):
    data = request.json
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')

    # TODO: check if user already exists (optional)

    # Create a new user in the Firebase Realtime Database
    user_ref = db.reference('users')
    new_user_ref = user_ref.push()
    new_user_ref.set({
        'username': username,
        'email': email,
        'password': password,
        'categories': {}
    })

    # add a basic category to the user's shelf
    categories_ref = new_user_ref.child('categories')
    new_category_ref = categories_ref.push()
    new_category_ref.set({
        'category_name': 'Basic',
        'books': {}
    })

    return jsonify({'message': 'User created successfully!'}), 200


def add_category(request):
    data = request.json
    user_id = data.get('user_id')
    category_name = data.get('category_name')

    # TODO: check if category already exists in user's categories (optional)

    # Add the new category to the user's shelf in the Firebase Realtime Database
    user_ref = db.reference(f'users/{user_id}')
    categories_ref = user_ref.child('categories')
    new_category_ref = categories_ref.push()
    new_category_ref.set({
        'category_name': category_name,
        'books': {}
    })

    return jsonify({'message': 'Category added successfully!'}), 200


def create_book(request):
    data = request.json
    user_id = data.get('user_id')
    # category_id = data.get('category_id')
    category_names = data.get('category_names')
    title = data.get('title')
    # image_file = request.files.get('image_file')
    image_url = data.get('image_url')
    songs = data.get('songs')

    # get category ids from category names
    category_ids = []
    for category_name in category_names:
        category_query = db.reference(f'users/{user_id}/categories').order_by_child(
            'category_name').equal_to(category_name).get()
        for key, value in category_query.items():
            category_ids.append(key)

    current_time = datetime.datetime.now().isoformat()

    # Add the new book to the user's category shelf in the Firebase Realtime Database
    user_ref = db.reference(f'users/{user_id}')
    books_ref = user_ref.child('books')
    new_book_ref = books_ref.push()
    new_book_ref.set({
        'title': title,
        'last_accessed': current_time,
        'images': [{
            'url': image_url,
            'songs': songs
        }],
    })

    # add book id in book ids list to each category
    for category_id in category_ids:
        category_ref = user_ref.child(f'categories/{category_id}')
        books_list = category_ref.child('books').get()
        if books_list and new_book_ref.key not in books_list:
            books_list.append(new_book_ref.key)
            category_ref.child('books').set(books_list)
        else:
            category_ref.child('books').set([new_book_ref.key])

    return jsonify({'message': 'Book added successfully!'}), 200


def update_book_access_time(request):
    data = request.json
    user_id = data.get('user_id')
    book_id = data.get('book_id')

    current_time = datetime.datetime.now().isoformat()

    # update last_accessed time of book
    user_ref = db.reference(f'users/{user_id}')
    book_ref = user_ref.child(f'books/{book_id}')
    book_ref.child('last_accessed').set(current_time)

    return jsonify({'message': 'Book access time updated successfully!'}), 200


def add_book_to_category(request):
    # add book id to category
    data = request.json
    user_id = data.get('user_id')
    category_name = data.get('category_name')
    book_name = data.get('book_name')

    category_query = db.reference(f'users/{user_id}/categories').order_by_child(
        'category_name').equal_to(category_name).get()
    category_id = None
    for key, _ in category_query.items():
        category_id = key

    book_query = db.reference(f'users/{user_id}/books').order_by_child(
        'title').equal_to(book_name).get()
    book_id = None
    for key, _ in book_query.items():
        book_id = key

    # Add the book_id to the category's books list
    user_ref = db.reference(f'users/{user_id}')
    category_ref = user_ref.child(f'categories/{category_id}')
    books_list = category_ref.child('books').get()
    if books_list and book_id not in books_list:
        books_list.append(book_id)
        category_ref.child('books').set(books_list)
    elif not books_list:
        category_ref.child('books').set([book_id])

    return jsonify({'message': 'Book added to category successfully!'}), 200


def add_song(request):
    data = request.json
    user_id = data.get('user_id')
    book_name = data.get('book_name')
    image_idx = data.get('image_idx')
    songs = data.get('songs')

    book_query = db.reference(f'users/{user_id}/books').order_by_child(
        'title').equal_to(book_name).get()
    book_id = None
    for key, _ in book_query.items():
        book_id = key

    # Add the song to the image's songs list
    user_ref = db.reference(f'users/{user_id}')
    image_ref = user_ref.child(f'books/{book_id}/images/{image_idx}')
    songs_list = image_ref.child('songs').get()
    if songs_list:
        for song in songs:
            if song not in songs_list:
                songs_list.append(song)
        image_ref.child('songs').set(songs_list)
    else:
        image_ref.child('songs').set(songs)

    return jsonify({'message': 'Songs added successfully!'}), 200


def remove_book_from_category(request):
    try:
        # remove book id from category
        data = request.json
        user_id = data.get('user_id')
        category_name = data.get('category_name')
        book_name = data.get('book_name')

        if not user_id or not category_name or not book_name:
            return jsonify({'error': 'Missing user_id, category_name, or book_name in the request.'}), 400

        category_query = db.reference(f'users/{user_id}/categories').order_by_child(
            'category_name').equal_to(category_name).get()
        category_id = None
        for key, _ in category_query.items():
            category_id = key

        if not category_id:
            return jsonify({'error': 'Category not found for the given user.'}), 404

        book_query = db.reference(f'users/{user_id}/books').order_by_child(
            'title').equal_to(book_name).get()
        book_id = None
        for key, _ in book_query.items():
            book_id = key

        if not book_id:
            return jsonify({'error': 'Book not found for the given user.'}), 404

        # Remove the book_id from the category's books list
        user_ref = db.reference(f'users/{user_id}')
        category_ref = user_ref.child(f'categories/{category_id}')
        books_list = category_ref.child('books').get()
        if books_list and book_id in books_list:
            books_list.remove(book_id)
            category_ref.child('books').set(books_list)

        return jsonify({'message': 'Book removed from category successfully!'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


def get_user_info(uid):
    try:
        # Assuming you have a users collection in Firebase Realtime Database
        user_data = db.reference('users').child(uid).get()
        if user_data:
            return jsonify(user_data)
        else:
            return jsonify({'error': 'User not found'}), 404
    except auth.AuthError as e:
        return jsonify({'error': str(e)}), 400
