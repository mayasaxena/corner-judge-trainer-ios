//
//  ControlEvent.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 12/9/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation

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
    let participantID: String

    let category: Category
    let color: PlayerColor?
    let value: Int?

    init(operatorID: String, category: Category, color: PlayerColor? = nil, value: Int? = nil) {
        self.participantID = operatorID
        self.category = category
        self.color = color
        self.value = value
    }
}

extension ControlEvent {
    var time: String? {
        return nil
//        return data[JSONKey.time]
    }

    var scoringDisabled: Bool? {
        return nil
//        return data[JSONKey.scoringDisabled]?.boolValue
    }

    var round: Int? {
        return nil
//        return data[JSONKey.round]?.int
    }
}

private extension Double {
    var toInt: Int? {
        return Int(self)
    }
}
