//
//  JoinMatchTableViewCellViewModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 11/20/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation
import RxSwift

class JoinMatchTableViewCellViewModel {

    let redPlayerName: Variable<String>
    let bluePlayerName: Variable<String>

    init() {
        redPlayerName = Variable("Red")
        bluePlayerName = Variable("Blue")
    }
}
