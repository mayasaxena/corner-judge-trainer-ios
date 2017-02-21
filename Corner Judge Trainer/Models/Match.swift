//
//  Match.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation

public final class Match {

    private struct Constants {
        static let matchIDLength = 3
        static let maxScore = 99.0
        static let restTime = 30.0
        static let pointGapValue = 12.0
        static let penaltyMax = 5.0
    }

    let id = Int.random(3)
    var matchType: MatchType

    var isWon: Bool {
        return winningPlayer != nil
    }

    var restTimeInterval: TimeInterval {
        return TimeInterval(Constants.restTime)
    }

    var round: Int = 1 {
        didSet {
            round = min(round, matchType.roundCount)
        }
    }

    fileprivate let date = Date()

    fileprivate(set) var redPlayer: Player
    fileprivate(set) var bluePlayer: Player

    fileprivate(set) var winningPlayer: Player?

    fileprivate(set) var redScore: Double = 0 {
        didSet {
            redScore = min(Constants.maxScore, redScore)
        }
    }

    fileprivate(set) var redPenalties: Double = 0 {
        didSet {
            redPenalties = min(redPenalties, 5.0)
        }
    }

    fileprivate(set) var blueScore: Double = 0 {
        didSet {
            blueScore = min(Constants.maxScore, blueScore)
        }
    }

    fileprivate(set) var bluePenalties: Double = 0 {
        didSet {
            bluePenalties = min(bluePenalties, 5.0)
        }
    }

    convenience init() {
        self.init(redPlayer: Player(color: .red), bluePlayer: Player(color: .blue), type: .none)
    }

    convenience init(type: MatchType) {
        self.init(redPlayer: Player(color: .red), bluePlayer: Player(color: .blue), type: type)
    }

    init(redPlayer: Player, bluePlayer: Player, type: MatchType) {
        self.redPlayer = redPlayer
        self.bluePlayer = bluePlayer

        matchType = type
    }

    func add(redPlayerName: String?, bluePlayerName: String?) {
        redPlayer.name = redPlayerName ?? redPlayer.name
        bluePlayer.name = bluePlayerName ?? bluePlayer.name
    }

    func updateScore(scoringEvent: ScoringEvent) {
        guard winningPlayer == nil else { return }

        var playerScore = 0.0
        var playerPenalties = 0.0

        switch scoringEvent.category {

        case .head:
            playerScore = 3

        case .body:
            playerScore = 1

        case .technical:
            playerScore = 1

        case .kyongGo:
            playerPenalties = 0.5

        case .gamJeom:
            playerPenalties = 1
        }

        if scoringEvent.color == .blue {
            blueScore += playerScore
            bluePenalties += playerPenalties
            redScore += playerPenalties
        } else {
            redScore += playerScore
            redPenalties += playerPenalties
            blueScore += playerPenalties
        }

        checkPenalties()
        checkPointGap()
    }

    private func checkPointGap() {
        if round > matchType.pointGapThresholdRound {
            if redScore - blueScore >= Constants.pointGapValue {
                winningPlayer = redPlayer
            } else if blueScore - redScore >= Constants.pointGapValue {
                winningPlayer = bluePlayer
            }
        }
    }

    private func checkPenalties() {
        if redPenalties >= Constants.penaltyMax {
            winningPlayer = bluePlayer
        } else if bluePenalties >= Constants.penaltyMax {
            winningPlayer = redPlayer
        }
    }

    func endMatch() {
        // TODO: Deal with ties
        winningPlayer = redScore > blueScore ? redPlayer : bluePlayer
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

    var roundDuration: TimeInterval {
        switch self {
        case .aTeam:
            return TimeInterval(2 * 60.0)
        case .bTeam:
            return TimeInterval(1.5 * 60.0)
        case .cTeam:
            return TimeInterval(1 * 60.0)
        default:
            return TimeInterval(10.0)
        }
    }

    var roundCount: Int {
        switch self {
        case .aTeam, .bTeam, .cTeam:
            return 2
        case .none:
            return 2
        default:
            return 3
        }
    }

    var pointGapThresholdRound: Int {
        switch self {
        case .aTeam, .bTeam, .cTeam, .none:
            return 0
        default:
            return 0
        }
    }

    static let caseCount = MatchType.countCases()

    fileprivate static func countCases() -> Int {
        // starting at zero, verify whether the enum can be instantiated from the Int and increment until it cannot
        var count = 0
        while let _ = MatchType(rawValue: count) { count += 1 }
        return count
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

extension Date {
    var timeStampString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyy h:mm a"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
