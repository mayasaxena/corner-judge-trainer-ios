//
//  Match.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 2/21/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation
import Genome

final class Match {

    private struct Constants {
        static let matchIDLength = 3
        static let maxScore = 99.0
    }

    let id: Int
    let date = Date()

    private(set) var redScore: Double = 0 {
        didSet {
            redScore = min(redScore, Constants.maxScore)
        }
    }

    private(set) var redPenalties: Double = 0 {
        didSet {
            redPenalties = min(redPenalties, ruleSet.maxPenalties)
        }
    }

    private(set) var blueScore: Double = 0 {
        didSet {
            blueScore = min(blueScore, Constants.maxScore)
        }
    }

    private(set) var bluePenalties: Double = 0 {
        didSet {
            bluePenalties = min(bluePenalties, ruleSet.maxPenalties)
        }
    }

    private(set) var winningPlayer: Player?

    fileprivate(set) var type: MatchType
    fileprivate(set) var ruleSet = RuleSet.ectc

    fileprivate(set) var redPlayer: Player
    fileprivate(set) var bluePlayer: Player

    init(id: Int = Int.random(3),
         redPlayerName: String? = nil,
         bluePlayerName: String? = nil,
         type: MatchType = .none) {
        self.id = id
        self.redPlayer = Player(color: .red, name: redPlayerName)
        self.bluePlayer = Player(color: .blue, name: bluePlayerName)
        self.type = type
    }

    convenience init(id: Int,
                     redPlayerName: String?,
                     bluePlayerName: String?,
                     type: MatchType,
                     redScore: Double,
                     redPenalties: Double,
                     blueScore: Double,
                     bluePenalties: Double) {

        self.init(id: id, redPlayerName: redPlayerName, bluePlayerName: bluePlayerName, type: type)

        self.redScore = redScore
        self.redPenalties = redPenalties
        self.blueScore = blueScore
        self.bluePenalties = bluePenalties
    }

    func handle(scoringEvent: ScoringEvent) {
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
    }

    var isWon: Bool {
        return winningPlayer != nil
    }

    func checkPointGap() {
        if redScore - blueScore >= ruleSet.pointGapValue {
            winningPlayer = redPlayer
        } else if blueScore - redScore >= ruleSet.pointGapValue {
            winningPlayer = bluePlayer
        }
    }

    func checkPenalties() {
        if redPenalties >= ruleSet.maxPenalties {
            winningPlayer = bluePlayer
        } else if bluePenalties >= ruleSet.maxPenalties {
            winningPlayer = redPlayer
        }
    }

    func determineWinner() {
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

enum MatchType: Int {
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

    static let allValues: [MatchType] = [.aTeam, .bTeam, .cTeam, .custom, .none]

    static var caseCount: Int {
        return allValues.count
    }
}

enum RuleSet: Int {
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

extension Match: CustomStringConvertible {
    var description: String {
        return
            "\nMatch \(id) (\(type.displayName)) at \(date.timeStampString)\n" +
            "Red Player: \(redPlayer.name)\t Score: \(redScore), Penalties: \(redPenalties)\n" +
            "Blue Player: \(bluePlayer.name)\t Score: \(blueScore), Penalties: \(bluePenalties)"
    }
}

extension Int {
    static func random(_ length: Int = 3) -> Int {
        return random(min: 10^^(length - 1), max: (10^^length) - 1)
    }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence

func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
