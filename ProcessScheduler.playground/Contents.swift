import Foundation
import ProcessSchedulerCore


/*
 * Homero Oliveira e Rafael Cadaval
 * O programa a seguir lê um arquivo e processa as informações, levando em conta sua prioridade, tempos de entrada e saída e tempos de acesso para execução.
 * Ele simula o escalonador de processos de um sistema operacional, usando o algoritmo Round Robin com prioridade como política de escaolnamento.
 * 04/10/2018
 */
guard let fileUrl = Bundle.main.url(forResource: "trab-so1-teste0SR", withExtension: "txt") else { fatalError() }

let input = readFile(from: fileUrl)

let processScheduller = ProcessScheduler()

let output = processScheduller.execute(input: input)

print(output.output)
print("average response Time = \(output.averageResponseTime)")
print("average wait Time = \(output.averageWaitTime)")
