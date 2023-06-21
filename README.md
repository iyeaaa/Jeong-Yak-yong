# 정약용[Prototype] - 정확한 약 복용

<br>

## 동기

* 약 개수가 늘어나 복용관리가 어려워짐 
* 약 설명서의 복잡합 + 설명서 보관 불편
* 매번 먹은 약 기록하기 부담스러움

<br>

## 기능

* 복용 일정 자동추가 시스템
* 약 복용법 및 주의사항 + 알람
* 건강기록(컨디션, 혈압, 혈당 등) 메모
* 약 복용 분석 통계

<br>

## Tech Stack

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white">
<img src="https://img.shields.io/badge/AWS lambda-FF9900?style=for-the-badge&logo=aws lambda&logoColor=white">
<img src="https://img.shields.io/badge/Amazon API gateway-FF4F8B?style=for-the-badge&logo=amazonapigateway&logoColor=white">
<img src="https://img.shields.io/badge/Firebase Auth-FFCA28?style=for-the-badge&logo=firebase&logoColor=white">
<img src="https://img.shields.io/badge/Cloud Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=white">

<br>

## 구현

* 사용자가 추가하려는 약의 정보를 Cloud Firestore에 저장 후 싱글톤 방식으로 불러옴
* API Gateway를 통해 서비스 단순화, 보안강화

<br>

## PAGES

|                                                    홈페이지                                                     |                                                     검색페이지                                                     |                                                    약 리스트                                                    |                                                       캘린더                                                       |
|:-----------------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------:|
| ![HomePage](https://github.com/iyeaaa/Jeong-Yak-yong/assets/102817453/98de16b4-2dc0-4085-b619-f9b60fc648b2) | ![SearchPage](https://github.com/iyeaaa/Jeong-Yak-yong/assets/102817453/b349fe84-aece-44bb-8682-81b2d8cdfcc5) | ![ListPage](https://github.com/iyeaaa/Jeong-Yak-yong/assets/102817453/e3c3e7e4-fcd0-4635-bb4c-78b15d985b11) | ![CalendarPage](https://github.com/iyeaaa/Jeong-Yak-yong/assets/102817453/13ae1ae0-5b6d-4bc6-a74d-f36e6e18f72b) |

<br>

[Original Design](https://www.figma.com/@helloghozi)
