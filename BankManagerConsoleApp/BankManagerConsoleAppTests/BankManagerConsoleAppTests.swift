//
//  BankManagerConsoleAppTests.swift
//  BankManagerConsoleAppTests
//
//  Created by Yongwoo Marco on 2021/07/27.
//

@testable import BankManagerConsoleApp
import XCTest

class BankManagerConsoleAppTests: XCTestCase {
    var sut = LinkedList<Int>()

    func test_실패케이스_링크드리스트의_push메서드를_호출하면_head노드에_새노드가추가된다() {
        // given
        let inputNumber = 1
        // when
        sut.push(inputNumber)
        // then
        XCTAssertNotEqual(sut.first?.value, nil)
    }
    
    func test_성공케이스_링크드리스트의_push메서드를_호출하면_head노드에_새노드가추가된다() {
        // given
        let inputNumber = 1
        // when
        sut.push(inputNumber)
        // then
        XCTAssertEqual(sut.first?.value, inputNumber)
    }
    
    func test_실패케이스_링크드리스트의_append메서드를_호출하면_tail노드에_새노드가추가된다() {
        // given
        let inputNumber = 1
        // when
        sut.append(inputNumber)
        // then
        XCTAssertNotEqual(sut.peekLastNode()?.value, nil)
    }
    
    func test_성공케이스_링크드리스트의_append메서드를_호출하면_taii노드에_새노드가추가된다() {
        // given
        let inputNumber = 1
        // when
        sut.append(inputNumber)
        // then
        XCTAssertEqual(sut.peekLastNode()?.value, inputNumber)
    }
    
    func test_실패케이스_링크드리스트의_clear을하면_노드의개수가_0이_나온다() {
        // given
        var dummyNodes = [
            DummyNode(value: 1, weakPointer: nil),
            DummyNode(value: 2, weakPointer: nil),
            DummyNode(value: 3, weakPointer: nil),
            DummyNode(value: 4, weakPointer: nil)
        ]
        dummyNodes.enumerated().forEach({ value in
            sut.append(value.element.value)
            dummyNodes[value.offset].weakPointer = sut.peekLastNode()
        })
        // when
        sut.clear()
        let result = dummyNodes.filter({ $0.weakPointer != nil }).count
        // then
        XCTAssertNotEqual(result, 4)
    }
    
    func test_성공케이스_링크드리스트의_clear을하면_노드의개수가_0이_나온다() {
        // given
        var dummyNodes = [
            DummyNode(value: 1, weakPointer: nil),
            DummyNode(value: 2, weakPointer: nil),
            DummyNode(value: 3, weakPointer: nil),
            DummyNode(value: 4, weakPointer: nil)
        ]
        dummyNodes.enumerated().forEach({ value in
            sut.append(value.element.value)
            dummyNodes[value.offset].weakPointer = sut.peekLastNode()
        })
        // when
        sut.clear()
        let result = dummyNodes.filter({ $0.weakPointer != nil }).count
        // then
        XCTAssertEqual(result, 0)
    }
    
    func test_실패케이스_링크드리스트의_popFirst매서드를_호출하면_head노드를_pop한다() {
        // given

        // when
        let popFirst = sut.popFirst()
        // then
        XCTAssertEqual(popFirst, nil)
    }
    
    func test_성공케이스_링크드리스트의_popFirst매서드를_호출하면_head노드를_pop한다() {
        // given
        let inputNumber = 1
        sut.push(inputNumber)
        // when
        let popFirst = sut.popFirst()!
        // then
        XCTAssertEqual(popFirst, inputNumber)
    }
}

struct DummyNode {
    let value: Int
    weak var weakPointer: Node<Int>?
}

extension Node: Equatable where T: Numeric {
    static func == (lhs: Node<T>, rhs: Node<T>) -> Bool {
        return lhs.value == rhs.value
    }
}

extension LinkedList {
    func peekLastNode() -> Node<T>? {
        var current = self.first
        while current?.next != nil {
            current = current?.next
        }
        return current
    }
}
