//
//  JoinMatchTableViewCellViewModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 11/20/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation
import RxSwift

final class JoinMatchTableViewCellViewModel {

    let redPlayerLabelText: String
    let bluePlayerLabelText: String
    let matchNumberLabelText: String
    // TODO: Match type once the designs are ready

    init(match: Match) {
        redPlayerLabelText = match.redPlayer.name.uppercased()
        bluePlayerLabelText = match.bluePlayer.name.uppercased()
        matchNumberLabelText = "MATCH \(match.id)"
    }

}
