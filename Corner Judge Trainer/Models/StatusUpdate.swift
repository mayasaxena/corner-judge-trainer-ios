//
//  StatusUpdate.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 12/11/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation

enum StatusUpdate: Decodable {
    enum StatusUpdateDecodingError: Error {
        case invalidStatusUpdate
    }

    enum CodingKeys: CodingKey {
        case data
    }

    enum DataCodingKeys: String, CodingKey {
        case score
        case penalties
        case timer
        case round
        case won = "winning_player"
    }

    enum ValueCodingKeys: String, CodingKey {
        case red
        case blue
        case displayTime = "display_time"
        case scoringDisabled = "scoring_disabled"
    }

    case score(red: Int, blue: Int)
    case penalties(red: Int, blue: Int)
    case timer(displayTime: String, scoringDisabled: Bool)
    case round(round: Int?)
    case won(winningColor: PlayerColor)

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .data)

        if dataContainer.contains(.score) {
            let scoreContainer = try dataContainer.nestedContainer(keyedBy: ValueCodingKeys.self, forKey: .score)
            let redScore = try scoreContainer.decode(Int.self, forKey: .red)
            let blueScore = try scoreContainer.decode(Int.self, forKey: .blue)
            self = .score(red: redScore, blue: blueScore)

        } else if dataContainer.contains(.penalties) {
            let penaltiesContainer = try dataContainer.nestedContainer(keyedBy: ValueCodingKeys.self, forKey: .penalties)
            let redPenalties = try penaltiesContainer.decode(Int.self, forKey: .red)
            let bluePenalties = try penaltiesContainer.decode(Int.self, forKey: .blue)
            self = .penalties(red: redPenalties, blue: bluePenalties)

        } else if dataContainer.contains(.timer) {
            let timerContainer = try dataContainer.nestedContainer(keyedBy: ValueCodingKeys.self, forKey: .timer)
            let displayTime = try timerContainer.decode(String.self, forKey: .displayTime)
            let scoringDisabled = try timerContainer.decode(Bool.self, forKey: .scoringDisabled)
            self = .timer(displayTime: displayTime, scoringDisabled: scoringDisabled)

        } else if dataContainer.contains(.round) {
            let round = try dataContainer.decodeIfPresent(Int.self, forKey: .round)
            self = .round(round: round)

        } else if dataContainer.contains(.won) {
            let winningColor = try dataContainer.decode(PlayerColor.self, forKey: .won)
            self = .won(winningColor: winningColor)

        } else {
            throw StatusUpdateDecodingError.invalidStatusUpdate
        }
    }
}

extension StatusUpdate: Equatable {
    public static func == (lhs: StatusUpdate, rhs: StatusUpdate) -> Bool {
        switch (lhs, rhs) {
        case (.score(let lhsRed, let lhsBlue), .score(let rhsRed, let rhsBlue)):
            return lhsRed == rhsRed && lhsBlue == rhsBlue
        case (.penalties(let lhsRed, let lhsBlue), .penalties(let rhsRed, let rhsBlue)):
            return lhsRed == rhsRed && lhsBlue == rhsBlue
        case (.timer(let lhsDisplayTime, let lhsScoringDisabled), .timer(let rhsDisplayTime, let rhsScoringDisabled)):
            return lhsDisplayTime == rhsDisplayTime && lhsScoringDisabled == rhsScoringDisabled
        case (.round(let lhsRound), .round(let rhsRound)):
            return lhsRound == rhsRound
        case (.won(let lhsWinner), .won(let rhsWinner)):
            return lhsWinner == rhsWinner
        default:
            return false
        }
    }
}

/*
 "event": "status",
 "data" : {
     "score: {
         "red" : "5"
         "blue" : "5"
     }
 // OR
     "penalties: {
         "red" : "5"
         "blue" : "5"
     }
 // OR
     "timer" : {
         "display_time" : "1:10"
         "scoring_disabled" : "false"
     }
 // OR
     "round" : "1",
 // OR
     "won" : "blue",
 }
 */
