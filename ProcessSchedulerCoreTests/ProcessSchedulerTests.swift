////
////  ProcessesSchedulerTests.swift
////  ProcessesSchedulerTests
////
////  Created by Homero Oliveira on 09/09/18.
////  Copyright © 2018 Homero Oliveira. All rights reserved.
////
//
import XCTest
@testable import ProcessSchedulerCore

class ProcessesSchedulerTests: XCTestCase {
    
    var processScheduler: ProcessScheduler!
    
    override func setUp() {
        super.setUp()
        processScheduler = ProcessScheduler()
    }
    
    func testTwoProcessWithDiferentsPriority() {
        let processes = [
            Process(id: 1, arrivalTime: 3, executionTime: 10, priority: 2),
            Process(id: 2, arrivalTime: 5, executionTime: 12, priority: 1)
        ]
        
        let input = ExecutionInput(processes: processes, quantum: 3)
        
        let output = processScheduler.execute(input: input)
        
        XCTAssertEqual("---C1C222C222C222C222C11C111C111C1", output.output)
    }
    
    func testTwoProcessWithSamePriorityAndSameArrivalTime() {
        let processes = [
                Process(id: 1, arrivalTime: 1, executionTime: 3, priority: 2),
                Process(id: 2, arrivalTime: 1, executionTime: 3, priority: 1),
                Process(id: 3, arrivalTime: 1, executionTime: 3, priority: 1)
        ]
        
        let input = ExecutionInput(processes: processes,
                                   quantum: 3)
        
        let output = processScheduler.execute(input: input)
        
        XCTAssertEqual("-C222C333C111", output.output)
    }
    
    func testFromMoodle() {
        let processes = [
            Process(id: 1, arrivalTime: 3, executionTime: 10, priority: 2),
            Process(id: 2, arrivalTime: 5, executionTime: 12, priority: 1),
            Process(id: 3, arrivalTime: 9, executionTime: 15, priority: 2),
            Process(id: 4, arrivalTime: 11, executionTime: 15, priority: 1),
            Process(id: 5, arrivalTime: 12, executionTime: 8, priority: 5,
                    accessToInOutOperations: [2])
        ]
        
        let input = ExecutionInput(processes: processes, quantum: 3)
        
        let output = processScheduler.execute(input: input)
        
        XCTAssertEqual("---C1C222C222C444C222C444C222C444C444C444C11C333C111C333C111C333C1C333C333C55C---C5C555C55", output.output)
        XCTAssertEqual(21.8, output.averageResponseTime, accuracy: 0.01)
    }
}
