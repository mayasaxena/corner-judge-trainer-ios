//
//  Match.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 2/21/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation
import Genome

public final class Match {

    private struct Constants {
        static let matchIDLength = 3
        static let maxScore = 99.0
    }

    public let id: Int
    public let date = Date()

    public var redScore: Double = 0 {
        didSet {
            redScore = min(redScore, Constants.maxScore)
        }
    }

    public var redPenalties: Double = 0 {
        didSet {
            redPenalties = min(redPenalties, ruleSet.maxPenalties)
        }
    }

    public var blueScore: Double = 0 {
        didSet {
            blueScore = min(blueScore, Constants.maxScore)
        }
    }

    public var bluePenalties: Double = 0 {
        didSet {
            bluePenalties = min(bluePenalties, ruleSet.maxPenalties)
        }
    }

    public var winningPlayer: Player?

    fileprivate(set) var type: MatchType
    fileprivate(set) var ruleSet = RuleSet.ectc

    fileprivate(set) var redPlayer: Player
    fileprivate(set) var bluePlayer: Player

    public init(
        id: Int = Int.random(3),
        redPlayer: Player = Player(color: .red),
        bluePlayer: Player = Player(color: .blue),
        type: MatchType = .none
    ) {

        self.id = id
        self.redPlayer = redPlayer
        self.bluePlayer = bluePlayer
        self.type = type
    }

    public func add(redPlayerName: String?, bluePlayerName: String?) {
        redPlayer.name = redPlayerName ?? redPlayer.name
        bluePlayer.name = bluePlayerName ?? bluePlayer.name
    }

    public func determineWinner() {
        if redScore == blueScore {
            winningPlayer = nil
        } else {
            winningPlayer = redScore > blueScore ? redPlayer : bluePlayer
        }
    }
}

extension String {
    var parsedDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyy h:mm a"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: self)
    }
}


// MARK: - MatchType

public enum MatchType: Int {
    case aTeam
    case bTeam
    case cTeam
    case custom
    case none

    var displayName: String {
        switch self {
        case .aTeam:
            return "A Team".uppercased()
        case .bTeam:
            return "B Team".uppercased()
        case .cTeam:
            return "C Team".uppercased()
        case .custom:
            return "Custom".uppercased()
        case .none:
            return "None".uppercased()
        }
    }
}

public enum RuleSet: Int {
    case ectc, wtf

    var maxPenalties: Double {
        switch self {
        case .ectc:
            return 5.0
        case .wtf:
            return 10.0
        }
    }

    var pointGapValue: Double {
        switch self {
        case .ectc:
            return 12.0
        case .wtf:
            return 20.0
        }
    }
}

extension Int {
    static func random(_ length: Int = 3) -> Int {
        let min = 10^^(length - 1)
        let max = (10^^length) - 1
        let top = max - min + 1
        return Int(arc4random_uniform(UInt32(top))) + min
    }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence

func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
