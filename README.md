# 2023Madcamp-Week3

# [몰입캠프 Week 4] - Olive (올리브)

<img src="https://github.com/pancakesontuesday/2023Madcamp-Week4/assets/128043904/743d6204-4b89-4639-8d38-0f79f6962f4a" alt="image" width="30%">

## 개발자 (Developers)

-   [홍은빈](https://github.com/pancakesontuesday), [김서경](https://github.com/seokyung1114),[신민영](https://github.com/myshin22)


## 기술 (Tech Stack)

Frontend: *Flutter*

Backend: *flask*
 
DB: *Firebase*
 
### APIs
*Youtube data* \
*Youtube player* \
*Google ocr* \
*Naver books* \
*Bard unofficial API: [here](https://github.com/dsdanielpark/Bard-API)* 


## 소개 (Introduction)

OLIVE는 나만의 책 playlist를 만들고 관리하는 앱입니다. 


## 기능 (Features)

### 로그인 / 회원가입
이메일과 비밀번호를 입력해 간편하게 회원가입할 수 있습니다. 각 회원의 책 정보, 노래 정보는 데이터베이스에서 관리하며 어느 디바이스에서든 로그인할 수 있습니다.


<img src="https://github.com/pancakesontuesday/2023Madcamp-Week4/assets/128043904/632c3385-c439-482a-a11f-9af728773d54" alt="image" width="30%">
<img src="https://github.com/pancakesontuesday/2023Madcamp-Week4/assets/128043904/af6ffbe3-69a5-4474-be5f-9da91b7e1c22" alt="image" width="30%">
<img src="https://github.com/pancakesontuesday/2023Madcamp-Week4/assets/128043904/91e6a087-476d-45e2-ba39-22fb1080a774" alt="image" width="30%">



### 홈화면
직접 만든 책장(카테고리)에 책을 분류해 보관할 수 있습니다. 각 책장은 가로로 스크롤하여 책을 선택할 수 있습니다. 책을 선택하면 해당 책에서 만들어진 플레이리스트를 확인할 수 있습니다. 책을 길게 누르면 책을 삭제할 수 있습니다.

<img src="https://github.com/pancakesontuesday/2023Madcamp-Week4/assets/128043904/96dd79b4-5027-4e31-815b-e353e6f1cd63" alt="image" width="30%">




### 책추가
하단 네비게이터바의 버튼을 이용해 책을 추가할 수 있습니다. 네이버 북스를 이용해 존재하는 책을 검색해 제목, 작가, 표지사진, 책 설명을 사용합니다. Google의 Bard unofficial API를 이용해 해당 책과 어울리는 노래를 추천받게 됩니다. 추천받은 노래는 유튜브 API를 이용해 유튜브 영상 정보를 가져와 추가할 수 있습니다. 책을 넣을 카테고리를 선택하고 책을 추가하면 회원 정보가 업데이트되며 책이 추가됩니다.

<img src="https://github.com/pancakesontuesday/2023Madcamp-Week4/assets/128043904/811dfb79-93d1-46e9-bca9-0e4846442e00" alt="image" width="30%">
<img src="https://github.com/pancakesontuesday/2023Madcamp-Week4/assets/128043904/4d7dee8e-d392-49f7-8728-93fda03202f4" alt="image" width="30%">


### 플레이리스트 / 노래 추가
책을 클릭해 열람하면 해당 책에 추가된 플레이리스트를 확인할 수 있습니다. 노래를 실행하면 유튜브 API를 이용해 영상을 틀며 노래가 재생됩니다. 
해당 탭에서 직접 노래를 추가하거나 글귀를 이용한 노래를 추천받을 수 있습니다. 직접 노래를 추가하면 유튜브에서 노래가 검색되며 검색어와 가장 유사한 상위 3개의 결과가 나타납니다. + 버튼을 이용해 검색한 노래를 추가할 수 있습니다. 책을 읽으며 인상깊은 글귀를 이용해 노래를 추천받을 수 있습니다. 책을 찍으면 Google OCR을 이용해 글을 인식하고, 해당 글귀를 Bard 모델에 집어넣고 5개의 추천곡을 받습니다. 책 추가와 유사하게, 추천곡은 유튜브에서 검색되어 나타나고 + 버튼을 이용해 추가할 수 있습니다.


<img src="https://github.com/pancakesontuesday/2023Madcamp-Week4/assets/128043904/752b28d0-970d-4c18-8201-4dd74377f61c" alt="image" width="30%">
<img src="https://github.com/pancakesontuesday/2023Madcamp-Week4/assets/128043904/60a8b5f0-0579-4bbd-8fd6-fb65630c2865" alt="image" width="30%">
<img src="https://github.com/pancakesontuesday/2023Madcamp-Week4/assets/128043904/c75129b4-1849-425e-90a7-617c8e7292bb4" alt="image" width="30%">


