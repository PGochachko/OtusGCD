//
//  JobQueue.swift
//  DataStructuresProfiling
//
//  Created by Павел on 31.05.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//

import Foundation
import Dispatch

struct JobQueue {
    typealias JobCompletion = (job: () -> TimeInterval, completion: (TimeInterval) -> Void)
    
    private var jobs: [JobCompletion] = []
    
    var count: Int { get { return jobs.count } }
    
    mutating func add(job: @escaping () -> TimeInterval, completion: @escaping (TimeInterval) -> Void) { jobs.insert((job, completion), at: 0) }
}

extension JobQueue: IteratorProtocol, Sequence {
    mutating func next() -> JobCompletion? { return jobs.popLast() }
}
