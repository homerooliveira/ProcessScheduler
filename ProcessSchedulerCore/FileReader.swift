//
//  FileReader.swift
//  ProcessSchedulerCore
//
//  Created by Homero Oliveira on 25/09/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

public struct FileReader {
    public let executionInput: ExecutionInput
    
    public init(fileUrl: URL) {
            let text = (try? String(contentsOf: fileUrl, encoding: .utf8)) ?? ""
            
            let contentsByLine = text.split(separator: "\n")
            let quantum = Int(contentsByLine[1])
            let rest = contentsByLine.dropFirst(2)
            let processes = rest.enumerated().compactMap { (arg) -> Process? in
                let (index, content) = arg
                let numbers = content.split(separator: " ")
                    .compactMap { Int($0) }
        
                guard numbers.count >= 3 else { return nil }
                return Process(id: index + 1,
                               arrivalTime: numbers[0],
                               executionTime: numbers[1],
                               priority: numbers[2],
                               accessToInOutOperations: Array(numbers.dropFirst(3)))
                }
            self.executionInput = ExecutionInput(processes: processes, quantum: quantum ?? 0)
    }
}
