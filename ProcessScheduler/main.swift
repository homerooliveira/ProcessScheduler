//
//  main.swift
//  ProcessesScheduler
//
//  Created by Homero Oliveira on 08/09/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

var proccess = [
    Process(id: 1, arrivalTime: 3, executionTime: 10, priority: 2),
    Process(id: 2, arrivalTime: 5, executionTime: 12, priority: 1),
        Process(id: 3, arrivalTime: 9, executionTime: 15, priority: 2),
        Process(id: 4, arrivalTime: 11, executionTime: 15, priority: 1),
        Process(id: 5, arrivalTime: 12, executionTime: 8, priority: 5,
                accessToInOutOperations: [2])
]

let processScheduller = ProcessScheduler()
let input = ExecutionInput(processes: proccess, quantum: 3)
print(processScheduller.execute(input: input).output)
