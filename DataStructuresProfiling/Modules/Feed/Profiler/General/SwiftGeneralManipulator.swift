//
//  GeneralManipulator.swift
//  DataStructuresProfiling
//
//  Created by Павел on 31.05.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//

import Foundation

open class SwiftGeneralManipulator {
    
    fileprivate let arrayManipulator: ArrayManipulator = SwiftArrayManipulator()
    fileprivate let dictionaryManipulator: DictionaryManipulator = SwiftDictionaryManipulator()
    fileprivate let setManipulator: SetManipulator = SwiftSetManipulator()
    
    func runCreation10000(times: Int, numberOfThreads: Int, jobCompletions: [CollectionType: (TimeInterval) -> Void], completion: @escaping () -> Void) {
        var jobQueue = JobQueue()
        for (type, completion) in jobCompletions {
            jobQueue.add(job: {return self.everythingCreation(10_000, times, type)}, completion: completion)
        }
        let jobScheduler = JobScheduler(queue: jobQueue, count: numberOfThreads, qos: .default, completion: completion)
        jobScheduler.run()
    }
    
    private func everythingCreation(_ size: Int, _ times: Int, _ type: CollectionType) -> TimeInterval {
        var result: TimeInterval = 0
        for _ in 0..<times {
            switch type {
            case .array:
                result += arrayManipulator.setupWithObjectCount(size)
            case .dictionary:
                result += dictionaryManipulator.setupWithEntryCount(size)
            case .set:
                result += setManipulator.setupWithObjectCount(size)
            }
        }
        return result
    }
}
