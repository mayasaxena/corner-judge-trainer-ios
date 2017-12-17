//
//  Match.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 2/21/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation
import Genome

final class Match: Decodable {

    public static let pointGapThresholdRound = 2
    public static let pointGapValue = 20
    public static let maxPenalties = 10

    private struct Constants {
        static let matchIDLength = 3
        static let maxScore = 99
    }

    let id: Int
    let date: Date
    let type: MatchType

    let redPlayer: Player
    let bluePlayer: Player

    private(set) var winningPlayer: Player?

    private(set) var redScore: Int = 0 {
        didSet {
            redScore = min(redScore, Constants.maxScore)
        }
    }

    private(set) var redPenalties: Int = 0 {
        didSet {
            redPenalties = min(redPenalties, Match.maxPenalties)
        }
    }

    private(set) var blueScore: Int = 0 {
        didSet {
            blueScore = min(blueScore, Constants.maxScore)
        }
    }

    private(set) var bluePenalties: Int = 0 {
        didSet {
            bluePenalties = min(bluePenalties, Match.maxPenalties)
        }
    }

    init(id: Int = Int.random(3),
         date: Date = Date(),
         redPlayerName: String? = nil,
         bluePlayerName: String? = nil,
         type: MatchType = .none) {

        self.id = id
        self.date = date
        self.redPlayer = Player(color: .red, name: redPlayerName)
        self.bluePlayer = Player(color: .blue, name: bluePlayerName)
        self.type = type
    }

    convenience init(id: Int,
                     date: Date,
                     redPlayerName: String?,
                     bluePlayerName: String?,
                     type: MatchType,
                     redScore: Int,
                     redPenalties: Int,
                     blueScore: Int,
                     bluePenalties: Int) {

        self.init(id: id, date: date, redPlayerName: redPlayerName, bluePlayerName: bluePlayerName, type: type)

        self.redScore = redScore
        self.redPenalties = redPenalties
        self.blueScore = blueScore
        self.bluePenalties = bluePenalties
    }

    func handle(scoringEvent: ScoringEvent) {
        guard winningPlayer == nil else { return }

        if scoringEvent.color == .blue {
            blueScore += scoringEvent.category.pointValue
        } else {
            redScore += scoringEvent.category.pointValue
        }
    }

    var isWon: Bool {
        return winningPlayer != nil
    }

    func checkPointGap() {
        if redScore - blueScore >= Match.pointGapValue {
            winningPlayer = redPlayer
        } else if blueScore - redScore >= Match.pointGapValue {
            winningPlayer = bluePlayer
        }
    }

    func checkPenalties() {
        if redPenalties >= Match.maxPenalties {
            winningPlayer = bluePlayer
        } else if bluePenalties >= Match.maxPenalties {
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

    func giveGamJeom(to color: PlayerColor) {
        switch color {
        case .blue:
            bluePenalties += 1
            redScore += 1
        case .red:
            redPenalties += 1
            blueScore += 1
        }
    }

    func removeGamJeom(from color: PlayerColor) {
        switch color {
        case .blue:
            guard bluePenalties > 0 else { return }
            bluePenalties -= 1
            redScore -= 1
        case .red:
            guard redPenalties > 0 else { return }
            redPenalties -= 1
            blueScore -= 1
        }
    }

    func adjustScore(for color: PlayerColor, byAmount amount: Int) {
        switch color {
        case .blue:
            if blueScore + amount >= 0 {
                blueScore += amount
            }
        case .red:
            if redScore + amount >= 0 {
                redScore += amount
            }
        }
    }
}

extension Match {
    private enum CodingKeys: CodingKey {
        case id
        case type
        case date
        case red
        case blue
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let type = try container.decode(MatchType.self, forKey: .type)
        let date = try container.decode(Date.self, forKey: .date)

        let redPlayerResponse = try container.decode(PlayerResponse.self, forKey: .red)
        let bluePlayerResponse = try container.decode(PlayerResponse.self, forKey: .blue)

        self.init(
            id: id,
            date: date,
            redPlayerName: redPlayerResponse.name,
            bluePlayerName: bluePlayerResponse.name,
            type: type,
            redScore: redPlayerResponse.score,
            redPenalties: redPlayerResponse.penalties,
            blueScore: bluePlayerResponse.score,
            bluePenalties: bluePlayerResponse.penalties
        )
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

enum MatchType: Int, Decodable {
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
