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
    var readyProcess: [[Process]] = Array(repeating: [], count: 9)
    var runningProcess: Process?
    var quatum: Int = 3
    var currentQuatum: Int = 0
    
    public init() {
    }
    
    public func execute(input: ExecutionInput) -> ExecutionOutput {
        quatum = input.quantum
        processes = input.processes
        currentQuatum = 0
        time = 1
        
        var output = ""
        
        while !processes.isEmpty || runningProcess != nil {
            if hasArrivalProcess(at: time) {
                let newProcess = processes.removeFirst()
                if runningProcess == nil {
                    changeContext(&output)
                    runningProcess = newProcess
                } else if let runningProcess = self.runningProcess {
                    if newProcess.priority < runningProcess.priority {
                        readyProcess[runningProcess.priority - 1].append(runningProcess)
                        changeContext(&output)
                        self.runningProcess = newProcess
                    } else {
                        readyProcess[newProcess.priority - 1].append(newProcess)
                    }
                }
            }
            
            executeCurrentProcess(&output)
        }
        return ExecutionOutput(processes: executedProcesses, output: output)
    }
    
    func executeCurrentProcess( _ output: inout String) {
        if var runningProcess = runningProcess {
            if !runningProcess.isFinished && currentQuatum < quatum {
                output += runningProcess.id.description
                runningProcess.execute()
                if currentQuatum == 0 {
                    runningProcess.executionTimes.append(Double(time))
                }
                self.runningProcess = runningProcess
                currentQuatum += 1
                time += 1
            } else {
                runningProcess.executionTimes.append(Double(time))
                if !runningProcess.isFinished {
                    readyProcess[runningProcess.priority - 1].append(runningProcess)
                } else {
                    self.executedProcesses.append(runningProcess)
                }
                
                guard let index = readyProcess.index(where: { !$0.isEmpty }) else {
                    self.runningProcess = nil
                    return
                }
                
                self.runningProcess = readyProcess[index].removeFirst()
                changeContext(&output)
            }
        } else {
            output += "-"
            time += 1
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
