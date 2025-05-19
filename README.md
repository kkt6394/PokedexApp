[![Typing SVG](https://readme-typing-svg.demolab.com?font=Bungee+Tint&size=35&pause=1000&color=F73B98&width=435&lines=Poke+dex)](https://git.io/typing-svg)

# 프로젝트 소개
Swift 기반으로 제작된 포켓몬 도감 애플리케이션입니다.

메인페이지에 포켓몬 리스트가 있으며, 클릭 시 세부 정보를 볼 수 있습니다.


# 주요 기능


+ 메인 화면의 포켓몬 이미지 클릭 시 세부 정보 확인 가능
+ 메인화면 스크롤 시 20개 씩 포켓몬 이미지 로드



# 사용 기술


+ Swift
+ UIKit
+ SnapKit
+ RxSwift
+ RxCocoa
+ RxRelay
+ Kingfisher



# 코드 설명 (MVVM 아키텍처)


## 1. Model 설정


+ 포켓몬 API: https://pokeapi.co/ 
+ 포켓몬 API를 기반으로 모델 구조 정리


## 2. NetworkManager


+ 싱글톤 패턴으로 NetworkManager 구현
+ 네트워크 로직이 필요한 모든 곳에서 사용 가능
+ URLSession을 통한 데이터 통신 이후 Observable을 리턴하는 메서드 구현
+ 메서드를 사용하는 부분에서 바로 이벤트 방출 가능


## 3. Translator

+ API에서 영문으로 오는 데이터를 한글로 번역


## 4. View (ViewController, CollectionViewCell)


+ MainViewController : 메인 화면 UI 설정 및 MainViewModel의 데이터(Observable)를 구독하여 UI 갱신
+ DetailViewController : 포켓몬 세부정보 UI 설정 및 DetailViewModel의 데이터를 구독하여 UI 갱신
+ PokeCell : 메인화면 포켓몬 리스트의 UI 설정

## 5. ViewModel 

+ ViewModel : NetworkManager 메서드를 활용하여 생성한 Observable에 이벤트를 방출하는 비즈니스 로직 담당

  


# 실행 방법


1. Xcode에서 프로젝트를 열고 실행 (Cmd + R)
2. 화면의 버튼을 눌러 계산 기능을 테스트
3. 잘못된 입력이 있을 경우 경고 메시지가 나타나는지 확인



# 향후 개선 사항


+ Kingfisher를 활용한 transition 기능 추가
+ RxSwift의 다양한 Observabel 활용한 리팩토링



# 개발자 정보


+ 이름: 김기태

+ 개발일: 2025-05-19
