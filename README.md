### 은행 매니저 프로젝트 저장소




  팀원 : 말꼬, 루얀

  기간 : 2021년 7월 26일 → 2021년 8월 6일



  실행 화면

  ---

  ![cpu_게이지](https://user-images.githubusercontent.com/57824307/129929638-e5de9809-4c00-4f51-b416-173186a4e396.gif)

  ![bankManager실행화면](https://user-images.githubusercontent.com/57824307/129929649-eedee85e-90be-4e4c-9f57-01c00cae8dd6.gif)



#### 코드 리뷰 
--- 
[Queue, LinkedList, Node 구현, Queue UnitTest](https://github.com/yagom-academy/ios-bank-manager/pull/69)

[BankManager Model Type 구현](https://github.com/yagom-academy/ios-bank-manager/pull/77)

[GCD를 활용한 비동기 프로그래밍](https://github.com/yagom-academy/ios-bank-manager/pull/88)

  ### issue & What I learn

  ---

  #### 🚨 Linked List 구조를 활용한 큐 타입 구현


  Queue 타입을 구현하기 위해 Node와 LinkedList를 구현했습니다.

  ```swift
      mutating func popFirst() -> T? {
          defer {
              head = head?.next
              if head == nil {
                  tail = nil
              }
          }
          return head?.value
      }
  ```

  Queue의 메소드 중 하나인 pop 메서드에 호출될 LinkedList의 popFirst() 메서드에서 `defer` 문법을 사용해보았습니다.


  `defer`은 현재 코드 블록을 나가기 전에 꼭 실행이 되야하는 코드를 작성해 마지막에 실행되도록 유도하는데 정상적으로 실행되지 않는 case는 다음과 같습니다.

  - defer이 작성된 곳 이전에 에러를 던질 경우
  - guard 문에 의해 조기종료 될 경우
  - 리턴값이 비반환함수(Never)일 경우



  #### 🚨  **DispatchQueue를 활용한 대기 행렬을 활용해 비동기 프로그래밍 진행**했고, **DispatchSemaphore을 활용해 동시에 작동하는 Thread의 개수를 제한**하였습니다.

  요청된 두 작업에 대해 각 작업은 서로 비동기적으로 작동해야 해서 privateQueue를 따로 만들어 작업 별로 동시성을 제한하는 방향으로 코드를 작성하였습니다.


  GCD의 3종류(main(serial), global(concurrent/ Qos 설정가능), private(serial or concurrent)) 중 현재 상황에는 
   private queue를 2개 만들고, 동시성을 제한하는 방법으로  `dispatchSemaphore` 의 `wait()`, `signal()`을 활용이 적절할 것 같다는 판단이 들었습니다.

  ```swift
  while let client = clientQueue.dequeue() {
              let bankingTask = client.bankingTask
              guard departments[bankingTask] != nil else { fatalError() }
              departments[bankingTask]?.dispatchQueue.async(group: servingGroup) { [self] in
                  departments[bankingTask]?.dispatchSemaphore.wait()
                  defer { departments[bankingTask]?.dispatchSemaphore.signal() }

                  guard let bankTeller = departments[bankingTask]?.assignBankTeller() 
                  else { fatalError() }
                  bankTeller.serve(client) {
                      clientCount += 1
                  }
                  departments[bankingTask]?.setup(bankTeller)
              }
          }
          servingGroup.wait()
  ```




  #### 🚨 타입 간의 관계에서 고민했던 부분


  App에서 사용하는 여러 타입 간의 관계를 UML로 표현했습니다.
  ![image-20210818220543178](https://user-images.githubusercontent.com/57824307/129989837-d9ca7cb0-f69f-4059-a7a1-293a63430291.png)




  ```swift
  class BankManager {
       let departments: Dictionary
       func open() {
             let bankTeller = departments[task].popLast()
             bankTeller.serve()
       }
  }

  struct BankTeller {
       func seve(_ client: Client) {
             print(client.description)
       }
  }
  ```


  BankTeller가 Client를 의존하는 관계는 참이라고 생각됐지만, BankManager과 Department, BankTeller간의 관계를 BankManger와 BankTeller의 관계를 의존 관계로 보는게 좋을지, BankManger에서 Department 프로퍼티 사용으로 보아야 하는지 고민했습니다.


  하지만 BankManager 인스턴스가 BankTeller에게 함수 호출을 요청하지 않으며, Department에게 BankTeller 내 함수 호출을 명령하고, 직접적으로는 Department가 BankTeller에게 명령한다는 생각에 BankManger에서 Department의 직접연관 관계가 맞고, BankManager이 BankTeller에 의존하진 않는다.라고 정리하였습니다.






  #### 🚨 스토리보드 없이 레이아웃 작성하기

  storyboard만을 이용해서 오토레이아웃을 적용했었는데, 코드만을 이용해 UI를 구성해보고 싶었습니다.

  ![image-20210818214313991](https://user-images.githubusercontent.com/57824307/129929990-3eaf734d-e8d5-49c0-898e-ff3520726ffe.png)

  오토레이아웃을 적용하기 위해 스토리보드 없이 NSLayoutConstraint, NSLayoutAnchor을 활용해 Scene을 구성하였습니다.


  ```swift
  // NSLayoutConstraint

  let top = NSLayoutConstraint.init(item: mainStackView,
              attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide,
              attribute: .top, multiplier: 1.0, constant: 0)
  let trailing = NSLayoutConstraint.init(item: mainStackView,
              attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide,
              attribute: .trailing, multiplier: 1.0, constant: 0)
  let leading = NSLayoutConstraint.init(item: mainStackView,
              attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide,
              attribute: .leading, multiplier: 1.0, constant: 0)
              NSLayoutConstraint.activate([top, trailing, leading])

  // NSLayoutAnchor

  workingScrollView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor).isActive = true
  workingScrollView.leadingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  workingScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  workingScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

  ```


  ```swift
  // MARK: TopButtonStackView(Elements)
  // 클로저를 활용한 동일한 형태의 버튼 생성
  let makeButton: (String, UIColor, Selector) -> UIButton = 
  { (title: String, Color: UIColor, function: Selector ) in
      let button = UIButton()
      button.setTitle("\(title)", for: .normal)
      button.addTarget(self, action: function, for: .touchUpInside)
      button.setTitleColor(Color, for: .normal)
      return button
  }

  ```

  ##### ❓ 스토리보드가 아닌 코드로 작성한 UI의 장점에 대한 개인적인 생각 

  유지 보수와 협업에 좋겠다는 생각이 들었습니다. 스토리보드 상에서 작은 변경 여부를 확인하기가 쉽지 않을 것 같습니다. 또한 스토리보드도 결국 코드화될텐데, 코드로의 직접 작성이 빌드 시간이 줄어들 것 같다는 생각이 듭니다. 하지만, 스토리보드를 활용한 방법과 코드를 사용하는 방법 모두 잘 익혀놔야겠다는 생각이 듭니다.

