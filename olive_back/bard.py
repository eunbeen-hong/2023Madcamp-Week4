from bardapi import Bard
import os
import json
import requests
import re

def get_response(book_name, author, ocr_text):
    api_key = None
    with open('secret/bard_api_key.json') as f:
        api_keys = json.load(f)['bard_api_keys']

    for i, api_key in enumerate(api_keys):

        os.environ['_BARD_API_KEY'] = api_key
        session = requests.Session()
        session.headers = {
            "Host": "bard.google.com",
            "X-Same-Domain": "1",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
            "Origin": "https://bard.google.com",
            "Referer": "https://bard.google.com/",
        }
        session.cookies.set("__Secure-1PSID", os.environ["_BARD_API_KEY"])

        search_term = f'{author}의 책 {book_name}의 {ocr_text}의 감정과 비슷한 한국 노래 5개를 1. 노래제목:가수 2. 노래제목:가수 ... 형태로 추천해줘. 노래 추천 외의 말은 하지 마'
        
        try: 
            bard = Bard(session=session)
            response = bard.get_answer(search_term)['content']
            return response
        except Exception as e:
            print(f"Error occurred with API key {i}th {api_key}: {e}")
            continue

    print("Sorry, all API keys are exhausted or an error occurred with all keys.")

    dummy = '''
    분노의 포도의 분노의 포도가 사람들의 영혼을 가득 채우며 점점 익어간다.의 감정과 비슷한 한국 노래 5개를 1. 노래제목:가수 2. 노래제목:가수 ... 형태로 추천하겠습니다.

    * 미안해요: 김광석
    * 걱정 말아요 그대: 이문세
    * 나의 외로움은 아름다워: 김민종
    * 사랑을 잃어버린 그대에게: 조용필
    * 슬픈 인생: 이문세

    이 노래들은 모두 분노, 슬픔, 고통과 같은 부정적인 감정을 다루고 있지만, 그럼에도 불구하고 희망과 용기를 잃지 않는 모습을 보여줍니다. 이러한 노래들은 분노의 포도가 사람들의 영혼을 가득 채우며 점점 익어간다.의 감정을 잘 표현하고 있다고 생각합니다.
'''

    # TODO: refine dummy so that when bard is not available, it still can return some good recommendations

    return dummy

def extract_song_author_pairs(text):
    # Use regex to find the song recommendations with various possible separators
    pattern = r'\* (.+?): (.+)'
    matches = re.findall(pattern, text)

    # Extract the song-title and artist pairs, considering the song line's length not to be over 30 characters
    song_author_pairs = [(title.strip(), author.strip()) for title, author in matches if len(title) <= 30]

    return song_author_pairs

# res = get_response("분노의 포도", "존 스타인벡", "분노의 포도가 사람들의 영혼을 가득 채우며 점점 익어간다.")
# print(res)
# songs = extract_song_author_pairs(res)
# print(songs)

def get_song_list(book_name, author, ocr_text):
    res = get_response(book_name, author, ocr_text)
    return extract_song_author_pairs(res)


# song_list = get_song_list("분노의 포도", "존 스타인벡", "분노의 포도가 사람들의 영혼을 가득 채우며 점점 익어간다.")
# print(song_list)