from flask import request, jsonify
import firebase_admin
from firebase_admin import db, auth
from google.cloud import storage
import datetime
import base64
from bard import get_song_list


def remove_book(request):
    try:
        data = request.json
        user_id = data.get('user_id')
        book_id = data.get('book_id')

        if user_id and book_id:
            # remove book
            user_ref = db.reference(f'users/{user_id}')
            book_ref = user_ref.child(f'books/{book_id}')

            if not book_ref.get():
                return jsonify({'error': 'Book not found for the given user.'}), 404

            book_ref.delete()

            # remove book id from all category (if exist)
            categories_ref = user_ref.child('categories')
            categories = categories_ref.get()
            if categories:
                for category_id, category in categories.items():
                    books = category.get('books')
                    if books and book_id in books:
                        books.remove(book_id)
                        categories_ref.child(f'{category_id}/books').set(books)

            return jsonify({'message': 'Book removed successfully!'}), 200
        else:
            print('Missing user_id or book_id.')
            return jsonify({'error': 'Missing user_id or book_id.'}), 400
    except Exception as e:
        print(str(e))
        return jsonify({'error': str(e)}), 500


def ocr_result(request):
    try:
        data = request.json
        book_name = data.get('book_name')
        author = data.get('author')
        text = data.get('text')

        if text:
            song_list = get_song_list(book_name, author, text)

            if song_list is not None:
                print("sending song list")
                return jsonify({'message': 'Text and image received and processed successfully!', 'song_list': song_list})
            else:
                print("sending 'beee'")
                return jsonify({'message': 'song list is null', 'song_list': ['beee']})

        else:
            return jsonify({'error': 'Missing text or image data.'})
    except Exception as e:
        print(str(e))
        return jsonify({'error': str(e)})


def send_text_and_image(request):
    try:
        data = request.json
        text = data.get('text')
        image = data.get('image')
        if text and image:
            # Decode the base64 image data
            image_bytes = base64.b64decode(image)

            # Create a unique filename for the image (you can use any method to generate a unique name)
            filename = 'image.jpg'

            bucket_name = 'madcamp4-olive.appspot.com'

            storage_client = storage.Client()
            bucket = storage_client.bucket(bucket_name)
            blob = bucket.blob(filename)
            blob.upload_from_string(image_bytes, content_type='image/jpeg')

            url = blob.public_url

            return jsonify({'message': 'Text and image received and processed successfully!', 'url': url})
        else:
            return jsonify({'error': 'Missing text or image data.'})
    except Exception as e:
        print(str(e))
        return jsonify({'error': str(e)})


def add_image_and_songs(request):
    try:
        data = request.json
        user_id = data.get('user_id')
        book_id = data.get('book_id')
        image = data.get('image')
        songs = data.get('songs')

        if image and songs:

            image_bytes = base64.b64decode(image)

            current_time = datetime.datetime.now().isoformat()
            filename = f"{user_id}/{user_id}_{current_time}.jpg"

            bucket_name = 'madcamp4-olive.appspot.com'

            storage_client = storage.Client()
            bucket = storage_client.bucket(bucket_name)
            blob = bucket.blob(filename)
            blob.upload_from_string(image_bytes, content_type='image/jpeg')

            url = blob.public_url

            print("bookId", book_id)
            images_ref = db.reference(
                f'users/{user_id}/books/{book_id}/images')
            images = images_ref.get()
            if images is None:
                images = []

            for song in songs:
                song['song_id'] = song.pop('songId')
                song['url'] = song.pop('songUrl')

            new_image_data = {
                'url': url,
                'songs': songs
            }

            images.append(new_image_data)
            images_ref.set(images)

            return jsonify({'message': 'Text and image received and processed successfully!', 'url': url})

        else:
            if not image:
                return jsonify({'error': 'Missing image'})
            elif not songs:
                return jsonify({'error': 'Missing songs'})
            else:
                return jsonify({'error': 'sth wrong here~'})
    except Exception as e:
        print(str(e))
        return jsonify({'error': str(e)})


def upload_image(request):
    try:
        # Assuming you receive the image data in the request JSON payload
        image_data = request.json.get('image')

        # Decode the base64 image data
        image_bytes = base64.b64decode(image_data)

        # Create a unique filename for the image (you can use any method to generate a unique name)
        filename = 'image.jpg'

        # Upload the image data to Firebase Storage
        storage_client = storage.Client()
        bucket = storage_client.bucket("madcamp4-olive.appspot.com")
        blob = bucket.blob(filename)
        blob.upload_from_string(image_bytes, content_type='image/jpeg')

        # Get the public URL of the uploaded image
        url = blob.public_url

        # Return the URL to the client or any other response you want
        return jsonify({'url': url}), 200

    except Exception as e:
        print("Error uploading image to Firebase Storage:", str(e))
        return jsonify({'error': 'Failed to upload image'}), 500


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
        print(str(e))
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
        'categories': {},
        'books': {},
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

    return jsonify({'message': 'Category added successfully!', 'category_id': new_category_ref.key}), 200


def create_book(request):
    data = request.json
    user_id = data.get('user_id')
    category_names = data.get('category_names')
    title = data.get('title')
    author = data.get('author')
    image_url = data.get('image_url')
    songs = data.get('songs')
    book_desc = data.get('book_desc')

    current_time = datetime.datetime.now().isoformat()

    # Add the new book to the user's category shelf in the Firebase Realtime Database
    user_ref = db.reference(f'users/{user_id}')
    books_ref = user_ref.child('books')
    new_book_ref = books_ref.push()
    new_book_ref.set({
        'title': title,
        'author': author,
        'last_accessed': current_time,
        'book_desc': book_desc,
        'images': [{
            'url': image_url,
            'songs': songs
        }],
    })

    # get category ids from category names
    category_ids = []
    for category_name in category_names:
        category_query = db.reference(f'users/{user_id}/categories').order_by_child(
            'category_name').equal_to(category_name).get()
        for key, value in category_query.items():
            category_ids.append(key)

    # add book id in book ids list to each category
    for category_id in category_ids:
        category_ref = user_ref.child(f'categories/{category_id}')
        books_list = category_ref.child('books').get()
        if books_list and new_book_ref.key not in books_list:
            books_list.append(new_book_ref.key)
            category_ref.child('books').set(books_list)
        else:
            category_ref.child('books').set([new_book_ref.key])

    return jsonify({'message': 'Book added successfully!', 'book_id': new_book_ref.key, 'last_accessed': current_time}), 200


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
        print(str(e))
        return jsonify({'error': str(e)}), 500


def get_user_info(email, password):
    try:
        users_ref = db.reference('users')
        user_data = None
        user_uid = None

        user_list = list(users_ref.get().values())

        for i, child in enumerate(user_list):
            if (child.get('email') == email and child.get('password') == password):
                user_data = child
                # Use the index to get the corresponding UID
                user_uid = list(users_ref.get().keys())[i]
                break

        if user_data is not None:
            # Found the user, return the user data as JSON along with the UID
            user_data['uid'] = user_uid
            # print('user logined successfully')
            # print(user_uid)
            # print(user_data)
            return jsonify({'message': 'Success', 'user_data': user_data}), 200
        else:
            # User not found, return failure message
            return jsonify({'message': 'Failed'}), 404
    except Exception as e:
        print(str(e))
        return jsonify({'error': str(e)}), 400
