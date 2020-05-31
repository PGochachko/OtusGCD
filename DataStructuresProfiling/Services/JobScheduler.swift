//
//  JobScheduler.swift
//  DataStructuresProfiling
//
//  Created by Павел on 31.05.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//

import Foundation
import Dispatch

class JobScheduler {

    private let queue: JobQueue
    private let concurrentQueue: DispatchQueue
    private let semaphore: DispatchSemaphore
    private let completion: () -> Void
    
    init(queue: JobQueue, count: Int, qos: DispatchQoS, completion: @escaping () -> Void) {
        self.queue = queue
        self.concurrentQueue = DispatchQueue(label: "jobScheduler.run", qos: qos, attributes: .concurrent)
        self.semaphore = DispatchSemaphore(value: count)
        self.completion = completion
    }
    
    func run() {
        let jobGroup = DispatchGroup()
        for elem in queue {
            self.semaphore.wait()
            concurrentQueue.async(group: jobGroup) {
                let time = elem.job()
                self.semaphore.signal()
                DispatchQueue.main.async {
                    elem.completion(time)
                }
            }
        }
        jobGroup.notify(queue: DispatchQueue.main) {
            self.completion()
        }
    }
}
