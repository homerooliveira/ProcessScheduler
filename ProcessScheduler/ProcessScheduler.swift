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
    var quatum: Int = 3
    var currentQuatum: Int = 0
    var inOutQuantum: Int = 4
    
    public init() {
    }
    
    public func execute(input: ExecutionInput) -> ExecutionOutput {
        quatum = input.quantum
        processes = input.processes
        currentQuatum = 0
        time = 1
        
        var output = ""
        
        while !processes.isEmpty || runningProcess != nil || !blockedProcess.isEmpty {
            if hasArrivalProcess(at: time) {
                let newProcess = processes.removeFirst()
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
        if !runningProcess.isFinished && currentQuatum < quatum {
            output += runningProcess.id.description
            runningProcess.execute()
            self.runningProcess = runningProcess
            currentQuatum += 1
            time += 1
            if runningProcess.isTimeToInOutOperation {
                runningProcess.executionTimes.append(Double(time))
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
                return
            }
            
            let process = readyProcesses[index].removeFirst()
            changeContext(to: process, &output)
        }
    }
    
    func hasArrivalProcess(at time: Int) -> Bool {
        guard let process = processes.first else {
            return false
        }
        return process.arrivalTime + 1 <= time
    }
    
    func changeContext(to process: Process?, _ output: inout String) {
        if output.last != "C" {
            output += "C"
            time += 1
        }
        runningProcess = process
        let lastCurrentQuantum = (runningProcess?.currentExecutionTime ?? quatum) % quatum
        currentQuatum = 0 + lastCurrentQuantum
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
