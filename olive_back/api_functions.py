from flask import request, jsonify
import firebase_admin
from firebase_admin import db
from google.cloud import storage


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
    # Handle image upload and processing here
    # Return some response indicating success
    return jsonify({'message': 'Image received and processed successfully!'})


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

    # Add the new book to the user's category shelf in the Firebase Realtime Database
    user_ref = db.reference(f'users/{user_id}')
    books_ref = user_ref.child('books')
    new_book_ref = books_ref.push()
    new_book_ref.set({
        "categoty": category_ids,
        'title': title,
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
    song = data.get('song')

    book_query = db.reference(f'users/{user_id}/books').order_by_child(
        'title').equal_to(book_name).get()

    book_id = None
    for key, _ in book_query.items():
        book_id = key

    # Add the song to the image's songs list
    user_ref = db.reference(f'users/{user_id}')
    image_ref = user_ref.child(f'books/{book_id}/images/{image_idx}')
    songs_list = image_ref.child('songs').get()
    if songs_list and song not in songs_list:
        songs_list.append(song)
        image_ref.child('songs').set(songs_list)
    else:
        image_ref.child('songs').set([song])

    return jsonify({'message': 'Song added successfully!'}), 200
