//
//  JoinMatchViewController.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 11/20/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit
import Intrepid

public final class JoinMatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let apiClient = CornerAPIClient()

    @IBOutlet weak var tableView: UITableView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        apiClient.getMatches()
        JoinMatchTableViewCell.registerNib(tableView)
    }

    // MARK: - UITableViewDataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ip_dequeueCell(indexPath, identifier: JoinMatchTableViewCell.cellIdentifier) as JoinMatchTableViewCell
        cell.configure(redPlayerName: "One", bluePlayerName: "Two")

        return cell
    }

    // MARK: - UITableViewDelegate

}
