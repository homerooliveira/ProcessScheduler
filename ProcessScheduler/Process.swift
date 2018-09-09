//
//  Process.swift
//  ProcessesScheduler
//
//  Created by Homero Oliveira on 08/09/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

public struct Process {
    public let id: Int
    public let arrivalTime: Int
    public let executionTime: Int
    public let priority: Int
    public var accessToInOutOperations: [Int]
    public var currentExecutionTime: Int = 0
    public var executionTimes: [Double] = []
    public var isFinished: Bool {
        return currentExecutionTime == executionTime
    }
    
    public init(id: Int,
                arrivalTime: Int,
                executionTime: Int,
                priority: Int,
                accessToInOutOperations: [Int] = []){
        self.id = id
        self.arrivalTime = arrivalTime
        self.executionTime = executionTime
        self.priority = priority
        self.accessToInOutOperations = accessToInOutOperations
    }
    
    public mutating func execute() {
        self.currentExecutionTime += 1
    }
}
