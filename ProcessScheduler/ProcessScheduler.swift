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
    var blockedProcess: Process?
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
        
        while !processes.isEmpty || runningProcess != nil || blockedProcess != nil {
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
            
            executeCurrentProcess(&output)
        }
        return ExecutionOutput(processes: executedProcesses.sorted(by: { $0.id < $1.id }), output: output)
    }
    
    
    
    func executeCurrentProcess( _ output: inout String) {
        if var runningProcess = runningProcess {
            runProcess(&runningProcess, &output)
        } else if let blockedProcess = self.blockedProcess {
            if currentQuatum < inOutQuantum {
                currentQuatum += 1
                output += "-"
            } else {
                self.blockedProcess = nil
                changeContext(to: blockedProcess, &output)
            }
        } else {
            output += "-"
            time += 1
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
                self.blockedProcess = runningProcess
                changeContext(to: nil, &output)
            }
        } else {
            if !runningProcess.isFinished {
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
        output += "C"
        runningProcess = process
        let lastCurrentQuantum = (runningProcess?.currentExecutionTime ?? quatum) % quatum
        currentQuatum = 0 + lastCurrentQuantum
        time += 1
        afterChangeContext()
    }
    
    func afterChangeContext() {
        guard var runningProcess = self.runningProcess else { return }
        runningProcess.executionTimes.append(Double(time))
        self.runningProcess = runningProcess
    }
}
