//
//  ProcessScheduler.swift
//  ProcessesScheduler
//
//  Created by Homero Oliveira on 08/09/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

public final class ProcessScheduler {
    
    private var time = 1
    var executedProcesses: [Process] = []
    var processes: [Process] = []
    var readyProcesses: [[Process]] = Array(repeating: [], count: 9)
    var runningProcess: Process?
    var blockedProcess: [Process] = []
    var quantum: Int = 3
    var currentQuantum: Int = 0
    var inOutQuantum: Int = 4
    
    public init() {
    }
    
    public func execute(input: ExecutionInput) -> ExecutionOutput {
        quantum = input.quantum
        processes = input.processes
        currentQuantum = 0
        time = 1
        
        var output = ""
        
        while !processes.isEmpty || runningProcess != nil || !blockedProcess.isEmpty {
            if let index = hasArrivalProcess(at: time) {
                let newProcess = processes.remove(at: index)
                if runningProcess == nil {
                    changeContext(to: newProcess, &output)
                } else if let runningProcess = self.runningProcess {
                    if newProcess.priority < runningProcess.priority {
                        readyProcesses[runningProcess.priority - 1].append(runningProcess)
                        changeContext(to: newProcess, &output)
                    } else {
                        readyProcesses[newProcess.priority - 1].append(newProcess)
                    }
                }
            }
            
            executeBlockedProcess()
            executeCurrentProcess(&output)
        }
        return ExecutionOutput(processes: executedProcesses.sorted(by: { $0.id < $1.id }), output: output)
    }
    
    func executeBlockedProcess() {
        var newBlockedProcesses = blockedProcess.map { $0.executeInOutOperation() }
        let suffix = newBlockedProcesses.partition { $0.currentExecutionInOut == inOutQuantum }
        newBlockedProcesses[suffix...].forEach { (process) in
            var newProcess = process
            newProcess.currentExecutionInOut = 0
            readyProcesses[process.priority - 1].append(newProcess)
        }
        newBlockedProcesses.removeSubrange(suffix...)
        
        self.blockedProcess = newBlockedProcesses
    }
    
    func executeCurrentProcess( _ output: inout String) {
        if var runningProcess = runningProcess {
            runProcess(&runningProcess, &output)
            return
        } else {
            output += "-"
            time += 1
        }
        
        if runningProcess == nil,
            let index = readyProcesses.index(where: { !$0.isEmpty }) {
            let process = readyProcesses[index].removeFirst()
            changeContext(to: process, &output)
        }
    }
    
    func runProcess(_ runningProcess: inout Process, _ output: inout String) {
        if !runningProcess.isFinished && currentQuantum < quantum {
            output += runningProcess.id.description
            runningProcess.execute()
            self.runningProcess = runningProcess
            currentQuantum += 1
            time += 1
            if runningProcess.isTimeToInOutOperation {
                blockedProcess.append(runningProcess)
                if let index = readyProcesses.index(where: { !$0.isEmpty }) {
                    let process = readyProcesses[index].removeFirst()
                    changeContext(to: process, &output)
                } else {
                    changeContext(to: nil, &output)
                }
                
            }
        } else {
            if !runningProcess.isFinished {
                runningProcess.executionTimes.append(Double(time))
                readyProcesses[runningProcess.priority - 1].append(runningProcess)
            } else {
                self.executedProcesses.append(runningProcess)
            }
            
            self.runningProcess = nil
            
            guard let index = readyProcesses.index(where: { !$0.isEmpty }) else {
                if !processes.isEmpty || !blockedProcess.isEmpty {
                    changeContext(to: nil, &output)
                }
                return
            }
            
            let process = readyProcesses[index].removeFirst()
            changeContext(to: process, &output)
        }
    }
    
    func hasArrivalProcess(at time: Int) -> Int? {
        guard let process = processes.first else {
            return nil
        }
        
        guard process.arrivalTime + 1 <= time else {
            return nil
        }
        
        let indexOfProcessWithHigherPriority = processes.dropFirst()
                    .firstIndex(where: { $0.priority < process.priority
                        && $0.arrivalTime == process.arrivalTime })
        
        return indexOfProcessWithHigherPriority ?? processes.startIndex
    }
    
    func changeContext(to process: Process?, _ output: inout String) {
        output += "C"
        time += 1
        runningProcess = process
        let lastCurrentQuantum = (runningProcess?.currentExecutionTime ?? quantum) % quantum
        currentQuantum = 0 + lastCurrentQuantum
        afterChangeContext()
        executeBlockedProcess()
    }
    
    func afterChangeContext() {
        guard var runningProcess = self.runningProcess else { return }
        let time = Double(self.time)
        runningProcess.executionTimes.append(Double(time))
        self.runningProcess = runningProcess
    }
}
