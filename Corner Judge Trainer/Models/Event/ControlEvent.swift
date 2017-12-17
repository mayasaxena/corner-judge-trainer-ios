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
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EventCodingKey.self)
        try container.encode(eventType.rawValue, forKey: .eventType)
        try container.encode(participantID, forKey: .participantID)
        var dataContainer = container.nestedContainer(keyedBy: EventCodingKey.self, forKey: .data)
        try dataContainer.encode(category.rawValue, forKey: .category)

        if let color = color {
            try dataContainer.encode(color.rawValue, forKey: .color)
        }
        if let value = value {
            try dataContainer.encode(value, forKey: .color)
        }
    }
}
