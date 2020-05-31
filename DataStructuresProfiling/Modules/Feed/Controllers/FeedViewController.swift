//
//  FeedViewController.swift
//  OTUS
//
//  Created by Дмитрий Матвеенко on 01/06/2019.
//  Copyright © 2019 GkFoxes. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    private let generalManipulator: SwiftGeneralManipulator = SwiftGeneralManipulator()
    
    private var feedData = Services.feedProvider.feedMockData()
    
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerNib = UINib.init(nibName: "DispatchView", bundle: Bundle.main)
        feedTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "DispatchView")
    }
    
    private func updateCellForType(_ type: CollectionType, time: TimeInterval) {
        feedData.indices.forEach{ feedData[$0].color = .black}
        if let index = feedData.firstIndex(where: { $0.type == type}) {
            feedData[index].time = time
        }
        let sortedFeed = feedData.filter({ $0.time > 0}).sorted{ $0.time < $1.time}
        if let maxIndex = feedData.firstIndex(where: { $0.type == sortedFeed.last?.type}), let minIndex = feedData.firstIndex(where: { $0.type == sortedFeed.first?.type}) {
            feedData[maxIndex].color = .red
            feedData[minIndex].color = .green
        }
        let indexPaths = (0..<feedData.count).map{ IndexPath(row: $0, section: 0)}
        feedTableView.reloadRows(at: indexPaths, with: .none)
    }
}

extension FeedViewController: UITableViewDataSource {
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseID, for: indexPath) as? FeedTableViewCell
        guard let feedCell = cell else { return UITableViewCell() }
        
        feedCell.updateCell(type: feedData[indexPath.row].type, time: feedData[indexPath.row].time, color: feedData[indexPath.row].color)
        return feedCell
    }
}

extension FeedViewController: UITableViewDelegate {
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var vc: UIViewController?
        
        if let currentCell = tableView.cellForRow(at: indexPath) as? FeedTableViewCell, let name = currentCell.nameLabel.text {
            switch name {
            case "Array":
                let storyboard = UIStoryboard(name: "DataStructures", bundle: nil)
                vc = storyboard.instantiateViewController(withIdentifier: "ArrayViewController")
            case "Set":
                let storyboard = UIStoryboard(name: "DataStructures", bundle: nil)
                vc = storyboard.instantiateViewController(withIdentifier: "SetViewController")
            case "Dictionary":
                let storyboard = UIStoryboard(name: "DataStructures", bundle: nil)
                vc = storyboard.instantiateViewController(withIdentifier: "DictionaryViewController")
            default:
                let storyboard = UIStoryboard(name: "Feed", bundle: nil)
                vc = storyboard.instantiateViewController(withIdentifier: "SessionSummaryViewController")
            }
        }
        
        if let pushViewController = vc {
            self.navigationController?.pushViewController(pushViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DispatchView") as! DispatchView
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 115 }
}

extension FeedViewController: DispatchDelegate {
    
    func run(numberOfTests: Int, numberOfThreads: Int, completion: @escaping () -> Void) {
        
        var completions = [CollectionType: (TimeInterval) -> Void]()
        for feed in feedData {
            completions[feed.type] = { time in
                self.updateCellForType(feed.type, time: time)
            }
        }
        generalManipulator.runCreation10000(times: numberOfTests, numberOfThreads: numberOfThreads, jobCompletions: completions, completion: completion)
    }
}
