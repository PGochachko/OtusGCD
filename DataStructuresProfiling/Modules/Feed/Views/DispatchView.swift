//
//  DispatchView.swift
//  DataStructuresProfiling
//
//  Created by Павел on 31.05.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//

import UIKit

protocol DispatchDelegate {
    func run(numberOfTests: Int, numberOfThreads: Int, completion: @escaping () -> Void)
}

class DispatchView: UITableViewHeaderFooterView {
    
    var delegate: DispatchDelegate?
    
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var countTestLabel: UILabel!
    @IBOutlet weak var countThreadsLabel: UILabel!
    
    private var numberOfTests: Int = 10 {
        didSet {
            countTestLabel?.text = "Количество тестов: \(numberOfTests)"
        }
    }
    
    private var numberOfThreads: Int = 1 {
        didSet {
            countThreadsLabel?.text = "Количество потоков: \(numberOfThreads)"
        }
    }
    
    @IBAction func sliderAdjusted(_ sender: UISlider) {
        numberOfTests = Int(ceil(sender.value))
    }
    
    @IBAction func runButtonTouched(_ sender: UIButton) {
        runButton.isEnabled = false
        DispatchQueue.global(qos: .default).async {
            self.delegate?.run(numberOfTests: self.numberOfTests, numberOfThreads: self.numberOfThreads) {
                self.runButton.isEnabled = true
            }
        }
    }
    @IBAction func stepperChanged(_ sender: UIStepper) {
        numberOfThreads = Int(sender.value)
    }
}
