//
//  Process.swift
//  ProcessesScheduler
//
//  Created by Homero Oliveira on 08/09/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

/// Representa o processo.
public struct Process: Equatable {
    public let id: Int
    public let arrivalTime: Int
    public let executionTime: Int
    public let priority: Int
    public var currentExecutionTime: Int = 0
    public var executionTimes: [Double] = []
    public var accessToInOutOperations: [Int] = []
    public var currentExecutionInOut: Int = 0
    
    public var isFinished: Bool {
        return currentExecutionTime == executionTime
    }
    
    public var isTimeToInOutOperation: Bool {
        return accessToInOutOperations.contains(where: { $0 == currentExecutionTime })
    }
    
    public var responseTime: Double {
        return executionTimes.first.map { $0 - Double(arrivalTime) } ?? 0
    }
    
    public init(id: Int,
                arrivalTime: Int,
                executionTime: Int,
                priority: Int,
                accessToInOutOperations: [Int] = []) {
        self.id = id
        self.arrivalTime = arrivalTime
        self.executionTime = executionTime
        self.priority = priority
        self.accessToInOutOperations = accessToInOutOperations
    }
    
    public mutating func execute() {
        currentExecutionTime += 1
    }
    
    public func executeInOutOperation() -> Process {
        var newProcess = self
        newProcess.currentExecutionInOut += 1
        return newProcess
    }
}

extension Process: Comparable {
    public static func < (lhs: Process, rhs: Process) -> Bool {
        return lhs.priority <= rhs.priority
    }
}
