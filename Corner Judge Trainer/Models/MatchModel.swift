//
//  MatchModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation

public enum MatchType: Int {
    case A_Team
    case B_Team
    case C_Team
    case Custom
    case None
    
    var displayName: String {
        switch self {
        case .A_Team:
            return "A Team".uppercaseString
        case .B_Team:
            return "B Team".uppercaseString
        case .C_Team:
            return "C Team".uppercaseString
        case .Custom:
            return "Custom".uppercaseString
        case .None:
            return "None".uppercaseString
        }
    }
    
    var roundDuration: NSTimeInterval {
        switch self {
        case .A_Team:
            return NSTimeInterval(2 * 60.0)
        case .B_Team:
            return NSTimeInterval(1.5 * 60.0)
        case .C_Team:
            return NSTimeInterval(1 * 60.0)
        default:
            return NSTimeInterval(10.0)
        }
    }
    
    var roundCount: Int {
        switch self {
        case .A_Team, .B_Team, .C_Team:
            return 2
        case .None:
            return 0
        default:
            return 3
        }
    }
    
    var pointGapThresholdRound: Int {
        switch self {
        case .A_Team, .B_Team, .C_Team, .None:
            return 0
        default:
            return 0
        }
    }
    
    static let caseCount = MatchType.countCases()
    
    private static func countCases() -> Int {
        // starting at zero, verify whether the enum can be instantiated from the Int and increment until it cannot
        var count = 0
        while let _ = MatchType(rawValue: count) { count += 1 }
        return count
    }
}

public class MatchModel {
    struct Constants {
        static let MatchIDLength = 6
        static let MaxScore = 99.0
        static let RestTime = 30.0
        static let PointGapValue = 12.0
    }
    
    var restTimeInterval: NSTimeInterval {
        return NSTimeInterval(Constants.RestTime)
    }

    let redPlayer: Player
    let bluePlayer: Player
    
    var winningPlayer: Player?

    var matchID: String
    var date: NSDate
    
    var matchType: MatchType
    
    var round: Int = 1 {
        didSet {
            round = min(round, matchType.roundCount)
            if round == matchType.roundCount {
                winningPlayer = redScore > blueScore ? redPlayer : bluePlayer
            }
        }
    }
    
    var redScore: Double {
        didSet {
            redScore = min(Constants.MaxScore, redScore)
        }
    }
    var blueScore: Double {
        didSet {
            blueScore = min(Constants.MaxScore, blueScore)
        }
    }
    
    static let sharedModel = MatchModel()
    
    convenience init() {
        self.init(redPlayer: Player(color: .Red), bluePlayer: Player(color: .Blue), type: .None)
    }
    
    convenience init(type: MatchType) {
        self.init(redPlayer: Player(color: .Red), bluePlayer: Player(color: .Blue), type: type)
    }

    init(redPlayer: Player, bluePlayer: Player, type: MatchType) {
        self.redPlayer = redPlayer
        self.bluePlayer = bluePlayer
        
        self.matchID = String.random(Constants.MatchIDLength)
        self.date = NSDate()
        self.redScore = 0
        self.blueScore = 0
        
        matchType = type
    }
    
    public func addPlayerNames(redPlayerName: String?, bluePlayerName: String?) {
        redPlayer.name = redPlayerName ?? redPlayer.name
        bluePlayer.name = bluePlayerName ?? bluePlayer.name
    }
    
    public func playerScored(playerColor: PlayerColor, scoringEvent: ScoringEvent) {
        var playerScore = 0.0
        var otherPlayerScore = 0.0
        
        switch scoringEvent {
            
        case .Head:
            playerScore = 3
            
        case .Body:
            playerScore = 1
            
        case .Technical:
            playerScore = 1
            
        // TODO: Fix so # of kyonggos increase instead
        case .KyongGo:
            otherPlayerScore = 0.5
            
        case .GamJeom:
            otherPlayerScore = 1
        }
        
        if playerColor == .Blue {
            blueScore += playerScore
            redScore += otherPlayerScore
        } else {
            redScore += playerScore
            blueScore += otherPlayerScore
        }
        
        checkPointGap()
    }
    
    private func checkPointGap() {
        if round > matchType.pointGapThresholdRound {
            if redScore - blueScore >= Constants.PointGapValue {
                winningPlayer = redPlayer
            } else if blueScore - redScore >= Constants.PointGapValue {
                winningPlayer = bluePlayer
            }
        }
    }
}

extension String {
    
    static func random(length: Int = 20) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.startIndex.advancedBy(Int(randomValue))])"
        }
        
        return randomString
    }
}
