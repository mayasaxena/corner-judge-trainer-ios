//
//  Event.swift
//  corner-judge-trainer-web
//
//  Created by Maya Saxena on 12/25/16.
//
//

import Foundation
import Genome

enum EventError: Swift.Error {
    case badThing
}

enum EventType: String {
    case control, scoring
}

extension EventType {
    init?(value: String?) {
        guard
            let value = value,
            let eventType = EventType(rawValue: value)
            else {
                return nil
            }

        self = eventType
    }
}

protocol Event {
    var eventType: EventType { get }
    var judgeID: String { get }
}

//
//extension Event {
//    var jsonString: String? {
//        return try? JSON(makeNode()).makeBytes().string()
//    }
//}

fileprivate struct JSONKey {
    static let eventType = "event"
    static let judgeID = "sent_by"
    static let data = "data"
    static let category = "category"
    static let color = "color"
}

// MARK: - ScoringEvent

struct ScoringEvent: Event {
    enum Category: String {
        case body
        case head
        case technical
        case kyongGo = "kyong-go"
        case gamJeom = "gam-jeom"

        var displayName: String {
            return rawValue.capitalized
        }
    }

    let eventType: EventType = .scoring
    let judgeID: String

    let color: PlayerColor
    let category: Category

    init?(node: Node) {
        guard
            let judgeID = node[JSONKey.judgeID]?.string,
            let dataObject = node[JSONKey.data]?.nodeObject,
            let color = dataObject[JSONKey.color]?.string,
            let category = dataObject[JSONKey.category]?.string
            else { return nil }

        self.init(color: color, category: category, judgeID: judgeID)
    }

    init(color: PlayerColor, category: Category, judgeID: String) {
        self.judgeID = judgeID
        self.color = color
        self.category = category
    }

    init?(color: String, category: String, judgeID: String) {
        guard
            let playerColor = PlayerColor(rawValue: color),
            let category = ScoringEvent.Category(rawValue: category)
            else {
                return nil
            }
        self.init(color: playerColor, category: category, judgeID: judgeID)
    }

//    func makeNode(context: Context) throws -> Node {
//        let data = [
//            JSONKey.color : color.rawValue,
//            JSONKey.category : category.rawValue
//        ]
//        return try Node(node: [
//            JSONKey.eventType : eventType.rawValue,
//            JSONKey.data : data.makeNode()
//            ])
//    }
}

extension ScoringEvent {

    var description: String {
        return "[\(color.displayName) \(category.displayName)]"
    }

    var isPenalty: Bool {
        return category == .gamJeom || category == .kyongGo
    }
}

extension ScoringEvent: Equatable {
    static func ==(lhs: ScoringEvent, rhs: ScoringEvent) -> Bool {
        return  lhs.category == rhs.category &&
            lhs.color == rhs.color
    }
}

// MARK: - ControlEvent

struct ControlEvent: Event {
    enum Category: String {
        case playPause
        case addJudge
        case timer
        case endMatch
    }

    let eventType: EventType = .control
    let judgeID: String

    let category: Category

    init?(node: Node) {
        guard
            let judgeID = node[JSONKey.judgeID]?.string,
            let dataObject = node[JSONKey.data]?.nodeObject,
            let categoryRaw = dataObject[JSONKey.category]?.string
            else { return nil }

        self.init(category: categoryRaw, judgeID: judgeID)
    }

    init(category: Category, judgeID: String) {
        self.category = category
        self.judgeID = judgeID
    }

    init?(category: String, judgeID: String) {
        guard let category = ControlEvent.Category(rawValue: category) else {
            return nil
        }
        self.init(category: category, judgeID: judgeID)
    }

//    func makeNode(context: Context) throws -> Node {
//        let data = [ JSONKey.category : category.rawValue ]
//        return try Node(node: [
//            JSONKey.eventType : eventType.rawValue,
//            JSONKey.data : data.makeNode()
//            ])
//    }
}

extension Node {
    func createEvent() -> Event? {
        guard let eventType = EventType(value: self["event"]?.string) else { return nil }

        switch eventType {
        case .scoring:
            return ScoringEvent(node: node)
        case .control:
            return ControlEvent(node: node)
        }
    }
}
