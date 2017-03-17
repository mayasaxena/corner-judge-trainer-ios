//
//  JoinMatchTableViewCellViewModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 11/20/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation
import RxSwift

public final class JoinMatchTableViewCellViewModel {

    public let redPlayerLabelText: String
    public let bluePlayerLabelText: String
    public let matchNumberLabelText: String
    // TODO: Match type once the designs are ready

    init(match: Match) {
        redPlayerLabelText = match.redPlayer.name.uppercased()
        bluePlayerLabelText = match.bluePlayer.name.uppercased()
        matchNumberLabelText = "MATCH \(match.id)"
    }

}
