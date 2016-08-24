//
//  MatchModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation

public enum PlayerColor {
    case Blue
    case Red
}

public class MatchModel {
    struct Constants {
        static let DefaultMatchID = "123"
        static let HeadshotPointValue = 3
        static let BodyshotPointValue = 1
    }

    var matchID: String
    var date: NSDate
    
    var redScore: Double = 0
    var blueScore: Double = 0
    
    convenience init() {
        self.init(matchID: Constants.DefaultMatchID, date: NSDate())
    }
    
    init(matchID id: String, date: NSDate) {
        self.matchID = id
        self.date = date
        self.redScore = 0
        self.blueScore = 0
    }
}
