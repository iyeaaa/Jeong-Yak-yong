# 정약용[Prototype] - 정확한 약 복용

### 프로젝트 배경

* 영양제를 챙겨 먹던 와중 진통제가 감기약을 더 챙겨 먹으려니 관리에 어려움을 느끼게 됨
* 약 복용법과 주의사항을 매번 찾기 귀찮고 볼 때마다 어렵게 느껴진다는 문제점
* 두통, 복통, 소화불량과 같은 일상에서 잘 나타나는 증상으로 약을 챙겨먹는 사람들을 위한 앱의 필요성

### 프로젝트 목적

* 일반의약품, 전문의약품을 모두 관리할 수 있는 앱
* 복잡하고 챙기기도 번거로운 약 설명서 없이 약 복용법 및 주의사항을 알 수 있는 앱
* 크지 않지만 작은 증상들이 나타나 약을 복용하는 사람들이 복용한 약들을 기록하여 건강관리를 할 수 있는 앱

### 기대효과

* 바쁜 현대인들이 간편하고 정확하게 약을 알고 복용할 수 있도록 도와, 건강회복을 잘할 수 있도록하고 하눈에 건강 상태를 파악해 건강을 유지할 수 있다.

### 프로토타입 소개영상

<p align="justify">
</p>


[![프로토타입 시연영상](http://img.youtube.com/vi/e-SODyj4cbM/0.jpg)](https://youtu.be/e-SODyj4cbM?t=0s)
<br>

## Tech Stack

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white">
<img src="https://img.shields.io/badge/AWS lambda-FF9900?style=for-the-badge&logo=aws lambda&logoColor=white">
<img src="https://img.shields.io/badge/Amazon API gateway-FF4F8B?style=for-the-badge&logo=amazonapigateway&logoColor=white">
<img src="https://img.shields.io/badge/Firebase Auth-FFCA28?style=for-the-badge&logo=firebase&logoColor=white">
<img src="https://img.shields.io/badge/Cloud Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=white">

<br>

## 기능 및 구현방식

1. 사용자가 추가하려는 약의 정보를 Cloud Firestore에 저장 후 싱글톤 방식으로 불러옴
2. API Gateway를 통해 서비스 단순화
3. 약 이름, 제약회사, 사진, 효능, 사용법을 바로 확인가능
4. 남은 약 개수를 기록해 현재 가진 약의 개수, 복용여부 확인 가능
5. 항목별로 주의사항을 나누어 편하게 확인 가능
6. 설정된 알람과 남은 개수를 토대로 자동으로 캘린더 일정 구성, 메모 가능
7. 약을 선택해 알람 설정 가능

## PAGES

|                                                    홈페이지                                                     |                                                     검색페이지                                                     |                                                    약 리스트                                                    |                                                       캘린더                                                       |
|:-----------------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------:|
| ![HomePage](https://github.com/iyeaaa/Jeong-Yak-yong/assets/102817453/98de16b4-2dc0-4085-b619-f9b60fc648b2) | ![SearchPage](https://github.com/iyeaaa/Jeong-Yak-yong/assets/102817453/b349fe84-aece-44bb-8682-81b2d8cdfcc5) | ![ListPage](https://github.com/iyeaaa/Jeong-Yak-yong/assets/102817453/e3c3e7e4-fcd0-4635-bb4c-78b15d985b11) | ![CalendarPage](https://github.com/iyeaaa/Jeong-Yak-yong/assets/102817453/13ae1ae0-5b6d-4bc6-a74d-f36e6e18f72b) |


<br>

