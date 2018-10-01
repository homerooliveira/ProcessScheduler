//: Playground - noun: a place where people can play

import Foundation
import ProcessSchedulerCore

guard let fileUrl = Bundle.main.url(forResource: "trab-so1-teste4SR", withExtension: "txt") else { fatalError() }

let input = readFile(from: fileUrl)

let processScheduller = ProcessScheduler()

let output = processScheduller.execute(input: input)

print(output.output)
print("average response Time = \(output.averageResponseTime)")
print("average wait Time = \(output.averageWaitTime)")
