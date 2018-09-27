//: Playground - noun: a place where people can play

import Foundation
import ProcessSchedulerCore

//var proccess = [
//    Process(id: 1, arrivalTime: 3, executionTime: 10, priority: 2),
//    Process(id: 2, arrivalTime: 5, executionTime: 12, priority: 1),
//    Process(id: 3, arrivalTime: 9, executionTime: 15, priority: 2),
//    Process(id: 4, arrivalTime: 11, executionTime: 15, priority: 1),
//    Process(id: 5, arrivalTime: 12, executionTime: 8, priority: 5,
//            accessToInOutOperations: [2])
//]
//let input = ExecutionInput(processes: proccess, quantum: 3)

guard let fileUrl = Bundle.main.url(forResource: "trab-so1-teste2SR", withExtension: "txt") else { fatalError() }

let input = readFile(from: fileUrl)

let processScheduller = ProcessScheduler()

let output = processScheduller.execute(input: input)

print(output.output)
print("average response Time = \(output.averageResponseTime)")
print("average wait Time = \(output.averageWaitTime)")
