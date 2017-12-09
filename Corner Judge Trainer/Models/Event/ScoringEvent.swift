//
//  ScoringEvent.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 12/9/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation
import Genome

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
    let judgeID: String
    let data: [String : String]

    var color: PlayerColor {
        guard
            let colorRaw = data[JSONKey.color],
            let color = PlayerColor(rawValue: colorRaw)
            else { fatalError("Scoring event must contain player color") }
        return color
    }

    var category: Category {
        guard
            let categoryRaw = data[JSONKey.category],
            let category = Category(rawValue: categoryRaw)
            else { fatalError("Scoring event must contain category data") }
        return category
    }

    init?(node: Node) {
        guard
            let judgeID = node[JSONKey.judgeID]?.string,
            let dataObject = node[JSONKey.data]?.nodeObject
            else { return nil }

        let data = dataObject.reduce([String : String]()) { dict, entry in
            var dictionary = dict
            dictionary[entry.key] = entry.value.string
            return dictionary
        }

        self.init(judgeID: judgeID, data: data)
    }

    init(judgeID: String, data: [String : String]) {
        self.judgeID = judgeID
        self.data = data

        if data[JSONKey.category] == nil {
            fatalError("Scoring event data must contain category data")
        }

        if data[JSONKey.color] == nil {
            fatalError("Scoring event data must contain player color")
        }
    }

    init(judgeID: String, category: Category, color: PlayerColor) {
        let data = [
            JSONKey.category : category.rawValue,
            JSONKey.color : color.rawValue
        ]
        self.init(judgeID: judgeID, data: data)
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
