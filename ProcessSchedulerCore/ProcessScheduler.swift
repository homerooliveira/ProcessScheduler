//
//  ProcessScheduler.swift
//  ProcessesScheduler
//
//  Created by Homero Oliveira on 08/09/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

public final class ProcessScheduler {
    
    /// Representa o tempo global.
    private var time = 1
    
    /// Representa os processos que já foram executados.
    var executedProcesses: [Process] = []
    
    /// Representa os processo que foram lidos do arquivo contendo os dados de entrada
    var processes: [Process] = []
    
    /// Representa as filas de espera com prioridade,onde cada indice + 1 representa uma prioridade.
    var readyProcesses: [[Process]] = Array(repeating: [], count: 9)
    
    /// Representa o processo que está sendo executado
    var runningProcess: Process?
    
    /// Representa os processos que estão bloqueado pois estão fazendo operações de E/S
    var blockedProcess: [Process] = []
    
    /// Representa a fatia de tempo que foi lida do arquivo contendo os dados de entrada.
    var quantum: Int = 3
    
    /// Representa o quantum atual do processo que está executando.
    var currentQuantum: Int = 0
    
    ///Representa a fatia de tempo para E/S que foi lida do arquivo contendo os dados de entrada.
    var inOutQuantum: Int = 4
    
    public init() {
    }
    
    /// Executa a simulação até o final e retorna o resultado da execução.
    public func execute(input: ExecutionInput) -> ExecutionOutput {
        resetVariables(input)
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
    
    /// Executa os processos que estão no array de bloqueados
    /// e remove eles da lista de bloqueados caso eles terminaram o seu tempo de E/S
    /// e é adicionado para lista de espera.
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
    
    /// É verificado se existe algum processo, se não é mostrado caracter "-"
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
    
    /// Executa-se o processo e é verficado se o proceso entra em operação de E/S
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
                if runningProcess.executionTimes.count == 1 {
                    let first = runningProcess.executionTimes.first!
                    runningProcess.executionTimes.append(first + 1)
                }
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
    
    /// É pesquisado se existe algum processo que chegou neste instante de tempo.
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
    
    /// Faz a troca de contexto para o processo ou para null.
    func changeContext(to process: Process?, _ output: inout String) {
        output += "C"
        time += 1
        runningProcess = process
        let lastCurrentQuantum = (runningProcess?.currentExecutionTime ?? quantum) % quantum
        currentQuantum = 0 + lastCurrentQuantum
        afterChangeContext()
        executeBlockedProcess()
    }
    
    /// Adiciona o tempo de entrada na lista de execução no processo que está rodando.
    func afterChangeContext() {
        guard var runningProcess = self.runningProcess else { return }
        let time = Double(self.time)
        runningProcess.executionTimes.append(time)
        self.runningProcess = runningProcess
    }
    
    /// Atualiza as variaveis para os valores inicias
    fileprivate func resetVariables(_ input: ExecutionInput) {
        quantum = input.quantum
        processes = input.processes
        currentQuantum = 0
        time = 1
        blockedProcess = []
        executedProcesses = []
        runningProcess = nil
        readyProcesses = Array(repeating: [], count: 9)
    }
}
