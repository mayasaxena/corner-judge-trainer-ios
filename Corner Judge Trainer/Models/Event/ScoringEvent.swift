//
//  ScoringEvent.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 12/9/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation

struct ScoringEvent: Event {
    enum Category: String {
        case body
        case head
        case technical

        var displayName: String {
            return rawValue.capitalized
        }

        var pointValue: Int {
            switch self {
            case .body:
                return 2
            case .head:
                return 3
            case .technical:
                return 1
            }
        }
    }

    let eventType: EventType = .scoring
    let participantID: String
    let category: Category
    let color: PlayerColor

    init(judgeID: String, category: Category, color: PlayerColor) {
        self.participantID = judgeID
        self.category = category
        self.color = color
    }
}

extension ScoringEvent {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EventCodingKey.self)
        try container.encode(eventType.rawValue, forKey: .eventType)
        try container.encode(participantID, forKey: .participantID)
        var dataContainer = container.nestedContainer(keyedBy: EventCodingKey.self, forKey: .data)
        try dataContainer.encode(category.rawValue, forKey: .category)
        try dataContainer.encode(color.rawValue, forKey: .color)
    }
}

extension ScoringEvent {
    var description: String {
        return "[\(color.displayName) \(category.displayName)]"
    }
}

extension ScoringEvent: Equatable {
    static func == (lhs: ScoringEvent, rhs: ScoringEvent) -> Bool {
        return lhs.category == rhs.category && lhs.color == rhs.color
    }
}
