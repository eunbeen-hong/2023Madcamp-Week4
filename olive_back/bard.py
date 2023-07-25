from bardapi import Bard
import os
import json
import requests

api_key = None
with open('secret/bard_api_key.json') as f:
    api_key = json.load(f)['bard_api_key']

# # After setting the API key as the environment variable
# os.environ['_BARD_API_KEY'] = api_key

# # Create a cookie jar and set the "__Secure-1PSID" cookie
# cookies = requests.cookies.RequestsCookieJar()
# cookies.set("__Secure-1PSID", os.environ["_BARD_API_KEY"], domain="bard.google.com", secure=True)

# # Attach the cookies to the session
# session = requests.Session()
# session.headers = {
#     "Host": "bard.google.com",
#     "X-Same-Domain": "1",
#     "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
#     "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
#     "Origin": "https://bard.google.com",
#     "Referer": "https://bard.google.com/",
# }
# session.cookies = cookies

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

author_name = '헤르만 헤세'
book_name = '데미안'
ocr = '어쩌구 저쩌구'

search_term = f'{author_name}의 책 {book_name}의 {ocr}의 감정과 비슷한 한국 노래 5개를 <노래제목>:<가수> 형태로 추천해줘'
# search_term = f'recommend 5 korean songs related to {ocr} in {book_name} by {author_name} in json format'

bard = Bard(session=session)
response = bard.get_answer(search_term)['content']

print(response)
