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
            .compactMap { $0.executionTimes.first }
        
        averageResponseTime = (sumOfResponseTime.sum - numberOfProcesses) / numberOfProcesses
        
        let sumOfWaitingTime = processes
            .map { (process) in
                return process.executionTimes
                        .chunked(by: 2)
                        .map { $0.last! - $0.first! }
                        .average
        }.sum

        averageWaitTime = sumOfWaitingTime / numberOfProcesses
    }
}
