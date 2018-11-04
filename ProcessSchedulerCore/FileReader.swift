//
//  FileReader.swift
//  ProcessSchedulerCore
//
//  Created by Homero Oliveira on 25/09/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

/// Lê o arquivo e retorna um Objeto contendo os dados.
public func readFile(from url: URL) -> ExecutionInput {
    let text = (try? String(contentsOf: url, encoding: .utf8)) ?? ""
    
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
    return ExecutionInput(processes: processes, quantum: quantum ?? 0)
}
