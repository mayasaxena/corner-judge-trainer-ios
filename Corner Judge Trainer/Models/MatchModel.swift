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
        static let HeadshotPointValue = 3
        static let BodyshotPointValue = 1
    }

    var matchID: String
    var date: NSDate
    
    var redScore: Double = 0
    var blueScore: Double = 0
    
    init(withMatchID matchID: String, andDate date: NSDate) {
        self.matchID = matchID
        self.date = date
    }
    
    public func playerScored(playerColor: PlayerColor, scoringEvent: ScoringEvent) {
        
        var playerScore: Double
        var otherPlayerScore: Double
        if playerColor == .Blue {
            playerScore = blueScore
            otherPlayerScore = redScore
        } else {
            playerScore = redScore
            otherPlayerScore = blueScore
        }
        
        switch scoringEvent {
            
        case .HeadKick:
            playerScore += 3
            
        case .SpinningHeadKick:
            playerScore += 4
            
        case .BodyKick:
            playerScore += 1
            
        case .SpinningBodyKick:
            playerScore += 3
            
        case .KyongGo:
            otherPlayerScore += 0.5
            
        case .GamJeom:
            otherPlayerScore += 1
            
        }
    }
}
