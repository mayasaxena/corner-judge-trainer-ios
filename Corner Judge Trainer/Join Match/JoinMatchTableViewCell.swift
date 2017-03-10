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

    func configure(with viewModel: JoinMatchTableViewCellViewModel) {
        redPlayerNameLabel.text = viewModel.redPlayerLabelText
        bluePlayerNameLabel.text = viewModel.bluePlayerLabelText
        matchNumberLabel.text = viewModel.matchNumberLabelText
    }
}
