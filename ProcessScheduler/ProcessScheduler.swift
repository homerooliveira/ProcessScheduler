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
                    changeContext(&output)
                    runningProcess = newProcess
                } else if let runningProcess = self.runningProcess {
                    if newProcess.priority < runningProcess.priority {
                        readyProcesses[runningProcess.priority - 1].append(runningProcess)
                        changeContext(&output)
                        self.runningProcess = newProcess
                    } else {
                        readyProcesses[newProcess.priority - 1].append(newProcess)
                    }
                }
            }
            
            executeCurrentProcess(&output)
        }
        return ExecutionOutput(processes: executedProcesses, output: output)
    }
    
    
    
    func executeCurrentProcess( _ output: inout String) {
        if var runningProcess = runningProcess {
            runProcess(&runningProcess, &output)
        } else if let blockedProcess = self.blockedProcess {
            if currentQuatum < inOutQuantum {
                currentQuatum += 1
                output += "-"
            } else {
                self.runningProcess = blockedProcess
                self.blockedProcess = nil
                changeContext(&output)
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
            if currentQuatum == 0 {
                runningProcess.executionTimes.append(Double(time))
            }
            self.runningProcess = runningProcess
            currentQuatum += 1
            time += 1
            if runningProcess.isTimeToInOutOperation {
                self.runningProcess = nil
                self.blockedProcess = runningProcess
                changeContext(&output)
            }
        } else {
            if !runningProcess.isFinished {
                readyProcesses[runningProcess.priority - 1].append(runningProcess)
            } else {
                self.executedProcesses.append(runningProcess)
            }
            
            guard let index = readyProcesses.index(where: { !$0.isEmpty }) else {
                self.runningProcess = nil
                return
            }
            
            self.runningProcess = readyProcesses[index].removeFirst()
            changeContext(&output)
        }
    }
    
    func hasArrivalProcess(at time: Int) -> Bool {
        guard let process = processes.first else {
            return false
        }
        return process.arrivalTime + 1 <= time
    }
    
    func changeContext(_ output: inout String) {
        output += "C"
        currentQuatum = 0
        time += 1
    }
}
