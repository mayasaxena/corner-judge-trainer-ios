//
//  JoinMatchTableViewCell.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 11/20/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit
import RxSwift
import Intrepid

public final class JoinMatchTableViewCell: UITableViewCell {
    @IBOutlet weak var redPlayerNameLabel: UILabel!
    @IBOutlet weak var bluePlayerNameLabel: UILabel!
    @IBOutlet weak var matchNumberLabel: UILabel!

    func configure(redPlayerName: String, bluePlayerName: String) {
        redPlayerNameLabel.text = redPlayerName.capitalized
        bluePlayerNameLabel.text = bluePlayerName.capitalized
    }

}
