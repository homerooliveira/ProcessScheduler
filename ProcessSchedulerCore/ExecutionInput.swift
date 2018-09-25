//
//  ExecutionInput.swift
//  ProcessScheduler
//
//  Created by Homero Oliveira on 09/09/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

public struct ExecutionInput {
    public let processes: [Process]
    public let quantum: Int
    public init(processes: [Process], quantum: Int) {
        self.processes = processes
        self.quantum = quantum
    }
}
