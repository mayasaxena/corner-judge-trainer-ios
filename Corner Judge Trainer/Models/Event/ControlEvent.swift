//
//  ControlEvent.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 12/9/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation
import Genome

struct ControlEvent: Event {
    enum Category: String {
        case playPause
        case status
        case endMatch
        case giveGamJeom
        case removeGamJeom
        case adjustScore
    }

    let eventType: EventType = .control
    let judgeID: String
    let data: [String : String]

    var category: Category {
        guard
            let categoryRaw = data[JSONKey.category],
            let category = Category(rawValue: categoryRaw)
            else { fatalError("Control event must contain category data") }
        return category
    }

    var color: PlayerColor? {
        guard
            let colorRaw = data[JSONKey.color],
            let color = PlayerColor(rawValue: colorRaw)
            else { return nil }
        return color
    }

    var value: Int? {
        guard let valueString = data[JSONKey.value] else { return nil }
        return Double(valueString)?.toInt
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
            fatalError("Control event data must contain category data")
        }
    }

    init(judgeID: String, category: Category) {
        let data = [JSONKey.category : category.rawValue ]
        self.init(judgeID: judgeID, data: data)
    }
}

extension ControlEvent {
    var time: String? {
        return data[JSONKey.time]
    }

    var scoringDisabled: Bool? {
        return data[JSONKey.scoringDisabled]?.boolValue
    }

    var round: Int? {
        return data[JSONKey.round]?.int
    }
}

private extension Double {
    var toInt: Int? {
        return Int(self)
    }
}
