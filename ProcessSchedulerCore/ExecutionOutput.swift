//
//  ExecutionOutput.swift
//  ProcessScheduler
//
//  Created by Homero Oliveira on 09/09/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

public struct ExecutionOutput {
    public let processes: [Process]
    public let output: String
    public let averageResponseTime: Double
    public let averageWaitTime: Double
    
    public init(processes: [Process], output: String) {
        self.processes = processes
        self.output = output
        
        let numberOfProcesses = Double(processes.count)
        
        let sumOfResponseTime = processes
            .map { $0.responseTime }
        
        averageResponseTime = sumOfResponseTime.sum() / numberOfProcesses
        
        let sumOfWaitingTime = processes
            .map { (process) in
                return process.executionTimes
                        .chunked(by: 2)
                        .map { $0.last! - $0.first! }
            }
        
        let totalOfWaitingTime = zip(sumOfResponseTime, sumOfWaitingTime)
            .lazy
            .map { $1 + [$0] }
            .map { $0.sum() }
            .sum()

        averageWaitTime = totalOfWaitingTime / numberOfProcesses
    }
}
