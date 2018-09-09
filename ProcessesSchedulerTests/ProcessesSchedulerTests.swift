//
//  ProcessesSchedulerTests.swift
//  ProcessesSchedulerTests
//
//  Created by Homero Oliveira on 09/09/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import XCTest
@testable import Dummy

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
        
        XCTAssertEqual("---C1C222C222C222C222C111C111C111", output.output)
    }
    
}
