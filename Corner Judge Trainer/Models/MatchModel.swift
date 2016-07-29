//
//  MatchModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation

class MatchModel {
    var matchID: String
    var date: NSDate
    
    init(withMatchID matchID: String, andDate date: NSDate) {
        self.matchID = matchID
        self.date = date
    }
}
