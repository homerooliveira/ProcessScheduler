//: Playground - noun: a place where people can play

import Foundation
import ProcessSchedulerCore

//guard let fileUrl = Bundle.main.url(forResource: "trab-so1-teste0SR", withExtension: "txt") else { fatalError() }
//
//let input = readFile(from: fileUrl)

let input = ExecutionInput(processes: [
    Process(id: 1, arrivalTime: 1, executionTime: 3, priority: 2),
    Process(id: 2, arrivalTime: 1, executionTime: 3, priority: 1),
    Process(id: 3, arrivalTime: 1, executionTime: 3, priority: 1)
    ],
                           quantum: 3)

let processScheduller = ProcessScheduler()

let output = processScheduller.execute(input: input)

print(output.output)
print("average response Time = \(output.averageResponseTime)")
print("average wait Time = \(output.averageWaitTime)")
