//
//  JoinMatchViewController.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 11/20/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit
import Intrepid

class JoinMatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private struct Constants {
        static let JoinMatchTableViewCellIdentifier = "JoinMatchTableViewCell"
    }

    let apiClient = CornerAPIClient()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        apiClient.getMatches()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ip_dequeueCell(indexPath, identifier: Constants.JoinMatchTableViewCellIdentifier) as JoinMatchTableViewCell

        cell.configureWithName(name: "HI")

        return cell
    }

    // MARK: - UITableViewDelegate

}
