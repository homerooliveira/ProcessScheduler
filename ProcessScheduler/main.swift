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

//var proccess = [
//    Process(id: 1, arrivalTime: 1, executionTime: 4, priority: 1,
//            accessToInOutOperations: [2]),
//    Process(id: 2, arrivalTime: 2, executionTime: 4, priority: 1,
//            accessToInOutOperations: [2]),
//    
////            Process(id: 6, arrivalTime: 2, executionTime: 8, priority: 6, accessToInOutOperations: [3])
//]

let processScheduller = ProcessScheduler()
let input = ExecutionInput(processes: proccess, quantum: 3)
let output = processScheduller.execute(input: input)
print(output.output)
print("average wait Time = \(output.averageWaitTime)")
print("average response Time = \(output.averageResponseTime)")

//let path = "/Users/homerooliveira/College/ProcessesScheduler/ProcessScheduler/test1.txt"
//
//if let contents = try? String(contentsOfFile: path) {
//    let contentsByLine = contents.split(separator: "\n")
//    let quantum = Int(contentsByLine[1])
//    let rest = contentsByLine.dropFirst(2)
//    let processes = rest.enumerated().compactMap { (arg) -> Process? in
//        let (index, content) = arg
//        let numbers = content.split(separator: " ")
//            .compactMap { Int($0) }
//
//        guard numbers.count >= 3 else { return nil }
//        return Process(id: index + 1,
//                       arrivalTime: numbers[0],
//                       executionTime: numbers[1],
//                       priority: numbers[2],
//                       accessToInOutOperations: Array(numbers.dropFirst(3)))
//        }
//    print(ExecutionInput(processes: processes, quantum: quantum!))
//}
//
//precedencegroup Group { associativity: left }
//infix operator >>>: Group
//func >>> <A, B, C>(_ lhs: @escaping (A) -> B,
//                   _ rhs: @escaping (B) -> C) -> (A) -> C {
//    return { rhs(lhs($0)) }
//}
