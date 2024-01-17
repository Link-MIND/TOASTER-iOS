# TOASTER-iOS
<img src="https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white"/> <img src="https://img.shields.io/badge/Xcode-147EFB?style=flat-square&logo=Xcode&logoColor=white"/>    

더 이상 링크를 태우지 마세요. 토스트 먹듯이 간단하게!

- 33기 DO SOPT APP-JAM (2023.12.17 ~ )
- Development Environment : `iOS 15.0+` `Xcode 15.1`

<br>

## 🍎 iOS Developer

| [다예](https://github.com/yeahh315) | [민재](https://github.com/mini-min) | [준혁](https://github.com/Genesis2010) | [가현](https://github.com/mcrkgus) | 
| :--: | :--: | :--: | :--: |
| <img width="500" alt="다예" src="https://github.com/Link-MIND/TOASTER-iOS/assets/69389288/0bee30c9-a064-4a69-82c6-88f804d58d40"> | <img width="500" alt="민재" src="https://github.com/Link-MIND/TOASTER-iOS/assets/69389288/7765cb00-68d9-4888-a6f3-1a1c4a893079"> | <img width="500" alt="준혁" src="https://github.com/Link-MIND/TOASTER-iOS/assets/69389288/7faccb46-38dc-4da3-9dee-ac3fbb506971"> | <img width="500" alt="가현" src="https://github.com/Link-MIND/TOASTER-iOS/assets/69389288/97e70799-93ed-4cd6-8a1c-519594930d66"> |
| <p align = "center">`검색 페이지` `리마인드` | <p align = "center">`카테고리 페이지` `카테고리 세부` | <p align = "center">`소셜 로그인` `마이페이지` | <p align = "center">`메인 페이지` `링크 저장` |

<br>

## 📦 Libraries
| Library | Version | Description |
|:-----:|:-----:|:-----:|
| [**KakaoSDK**](https://github.com/kakao/kakao-ios-sdk) | 2.20.0 | 카카오 소셜 로그인 시 사용 |
| [**Moya**](https://github.com/Moya/Moya) | 15.0.0 | Networking 시 사용 |
| [**SnapKit**](https://github.com/SnapKit/SnapKit) | 5.6.0 | UI AutoLayout을 잡을 때 사용 |
| [**SwiftLint**](https://github.com/realm/SwiftLint) | 0.54.0 | 같은 iOS 개발자 사이, 코딩 컨벤션 규칙을 설정하는 데 사용 |
| [**Then**](https://github.com/devxoul/Then) | 3.0.0 | 클로저를 통한 인스턴스 초기화를 할 수 있도록 도와주는 라이브러리 |

<br>

## 📖 Coding Convention
### 1. Base Rule
- 기본적으로, Swiftlint를 적용시켜 Error와 Warning을 발생시키지 않도록 한다.
- 세부적인 사항은 아래 원칙을 따른다.
```
1. 더 이상 상속되지 않을 class에는 꼭 final 키워드를 붙이도록 한다.
2. class에서 사용되는 프로퍼티는 모두 private으로 선언하자. (외부에서 접근할 일이 있다면 함수를 통해 접근하도록 하자..)
3. 길어지더라도 약어와 생략을 지양하자 (VC, TVC, Config 등등 XXX → ViewController, TableViewCell, Configure)
4. Global 위치에 함수를 만들 것이면 퀵헬프 주석을 한 줄이라도 꼭 달아주자.
5. 강제 언래핑 사용 X
6. self를 되도록 빼기
7. Class, Struct, Enum : Upper / 나머지 : Lower
```
### 2. 네이밍
```
프로토콜 : ~~~Protocol의 형식을 사용하고, Delegate Protocol의 경우 ~~Delegate를 사용한다.

변수 : UI Property일 경우 어떤 UI Property인지 명시해주자 (예, informationStackView)

함수 :
 1) setupStyle(), setupHierarchy(), setupLayout(), setupCell()
 2) 함수 이름 형식은 주어+동사 혹은 주어+동사+목적어의 형태로 사용한다. (예, nextButtonTapped())
 3) API 관련 함수일 경우 GET POST PUT DELETE를 함수의 가장 앞에 붙인다.
 4) API 관련 함수를 제외하고 get set 사용을 지양한다. (대신 fetch setup 사용)
```
### 3. 개행
```
1. 기본 프레임워크를 가장 상단에 import 후, 개행 한 뒤 나머지 프레임워크를 ABC 순으로 적는다.
2. MARKDOWN 주석 위아래는 개행한다.
3. 나머지는 적당히 알아서 깔끔하고 센스있게.
```

<br>

## 🙌 Git Convention
### 1. Git-flow 전략
![Untitled](https://github.com/Link-MIND/TOASTER-iOS/assets/69389288/f26e6fbe-6b08-4c6d-b57d-46cbca9ef6d9)  
*main 대신 develop을 default 브랜치로 사용 (main은 릴리즈용)
```bash
1. 작업할 내용에 대해 이슈를 판다.
2. 내 로컬에서 develop 브랜치가 최신화 되어있는지 확인한다. (develop 브랜치는 항상 pull을 받아 최신화를 시키자)
3. develop 브랜치로부터 새 브랜치를 만든다. (브랜치명은 `커밋타입/#이슈번호-뷰이름`)
4. 만든 브랜치에서 작업을 한다
5. 커밋은 쪼개서 작성하며 커밋 메시지는 컨벤션을 따른다.
6. 작업할 내용을 다 끝내면 ⭐️⭐️⭐️에러가 없는지 잘 돌아가는지 (안터지는지) 확인⭐️⭐️⭐️한 후 push한다. 
7. PR을 작성한 후, 리뷰나 수정사항을 반영해준 뒤 develop에 merge한다. (단, PR시 추가되는 코드 줄 수를 500줄로 제한한다.)
```

### 2, Issue & PR title
- 담당자, 리뷰어, 라벨을 꼭 추가하도록 한다.
```bash
Issue : [종류] 작업명 (예시: [Feat] Main View UI 구현)

PR : [종류] #이슈번호 작업명 (예시: [Feat] #13 Main View UI 구현)
```

### 3, Commit Message
```bash
커밋 메시지 : `[종류] #이슈 - 작업 이름` - 예시 `[Feat] #13 - Main UI 구현`

Conflict 해결 시 : `[Conflict] #이슈 - Conflict 해결`

PR을 develop에 merge 시 : 기본 머지 메시지

내 브랜치에 develop merge 시 (브랜치 최신화) : `[Merge] #이슈 - Pull Develop` - `[Merge] #13 - Pull Develop`
```
#### 이모지와 태그별 사용 경우 (라벨로만 사용하기로!)
| 이모지 | 태그 | 사용 경우 |
| :--: | :--: | :--: |
| ✨ | Feat | 새로운 기능 구현 |
| 📦 | Add | 라이브러리 추가, 에셋 추가 |
| 🔧 | Chore | Feat 이외에 코드 수정, 내부 파일 수정, 애매한 것들이나 잡일은 이걸로! |
| 💄 | Design | UI 디자인을 구현하거나 변경합니다. |
| 📝 | Docs | README나 wiki 등의 문서 개정 |
| 🐛 | Fix | 버그, 오류 해결 |
| ♻️ | Refactor | 기존 코드 리팩토링 (성능 개선) | 
| 🔥 | Del | 쓸모없는 코드, 파일 지우기 |
| ⚙️ | Setting | 프로젝트 설정관련이 있을 때 사용합니다. |

### 4. Code Review
```bash
P1 : 꼭 반영해주세요

P2 : 반영하면 좋을 것 같습니다.

P3 : 단순 의견 제시 (무시해도 됩니다)

예) P1 ) 컨벤션에 따라 함수 네이밍을 ~~로 바꿔야 할 것 같아요! 
```

<br>

### 📂 Foldering Convention
```bash
├── .swiftlint
├── 📁 Application
│   ├── AppDelegate
│   ├── SceneDelegate
├── 📁 Global
|   ├── 🗂️ Protocols
|   ├── 🗂️ Components
│   ├── 🗂️ Consts
│   ├── 🗂️ Extensions
│   ├── 🗂️ Resources
│   │   ├── 🗂️ Font
│   │   ├── Assets
│   │   ├── LaunchScreen
│   ├── 🗂️ Supporting Files
│   │   ├── Info.plist
│   │   ├── Config
├── 📁 Network
│   ├── 🗂️ Base
│   ├── 🗂️ Home
│   │   ├── HomeAPI
│   │   ├── HomeService
├── 📁 Presentation
│   ├── 🗂️ WaitingDetail
│   ├── 🗂️ StoreDetail
│   ├── 🗂️ StoreList
│   ├── 🗂️ Home
│   │   │   ├── 🗂️ Model
│   │   │   ├── 🗂️ ViewController
│   │   │   ├── 🗂️ ViewModel
``` 
