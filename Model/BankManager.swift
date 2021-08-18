//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

enum BankingTask: CaseIterable, CustomStringConvertible {
    case deposit
    case loan
    
    var numberOfBankWindow: Int {
        switch self {
        case .deposit:
            return 2
        case .loan:
            return 1
        }
    }
    
    var processingTime: Double {
        switch self {
        case .deposit:
            return 0.7
        case .loan:
            return 1.1
        }
    }
    
    var description: String {
        switch self {
        case .deposit:
            return "예금"
        case .loan:
            return "대출"
        }
    }
}


final class BankManager {
    private var clientQueue: Queue<Client>
    private var departments: Dictionary<BankingTask, Department>
    private var clientCount: Int
    private var duration: Double
    
    init() {
        self.clientQueue = .init()
        self.departments = .init()
        for task in BankingTask.allCases {
            departments.updateValue(Department(bankingTask: task), forKey: task)
        }
        self.clientCount = 0
        self.duration = 0
    }
    
    func lineupClients(_ numberOfClients: Int = Int.random(in: 10...30)) {
        for number in 1...numberOfClients {
            clientQueue.enqueue(Client(waitingNumber: number))
        }
    }
    
    func open() {
        let servingGroup = DispatchGroup()
        let startTime = CFAbsoluteTimeGetCurrent()
        defer { duration = CFAbsoluteTimeGetCurrent() - startTime }
        
        while let client = clientQueue.dequeue() {
            let bankingTask = client.bankingTask
            guard departments[bankingTask] != nil else { fatalError() }
            departments[bankingTask]?.dispatchQueue.async(group: servingGroup) { [self] in
                departments[bankingTask]?.dispatchSemaphore.wait()
                defer { departments[bankingTask]?.dispatchSemaphore.signal() }
                
                guard let bankTeller = departments[bankingTask]?.assignBankTeller() else { fatalError() }
                bankTeller.serve(client) {
                    clientCount += 1
                }
                departments[bankingTask]?.setup(bankTeller)
            }
        }
        servingGroup.wait()
    }
    
    func close() {
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(clientCount)명이며, ", terminator: "")
        print("총 업무시간은\(String(format: "%.2f", duration))초입니다.")
        self.clientCount = 0
        self.duration = 0
    }
}
