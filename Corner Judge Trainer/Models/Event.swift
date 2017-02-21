//
//  Event.swift
//  corner-judge-trainer-web
//
//  Created by Maya Saxena on 12/25/16.
//
//

import Foundation

enum EventType: String {
    case control, scoring
}

extension EventType {
    init?(value: String?) throws {
        guard
            let value = value,
            let eventType = EventType(rawValue: value)
            else {
                return nil
//                let message = "Event data must contain event type"
//                log(message)
//                throw Abort.custom(status: .badRequest, message: message)
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

public struct ScoringEvent: Event {
    public enum Category: String {
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

//    init(node: Node) throws {
//        guard
//            let judgeID = node[JSONKey.judgeID]?.string,
//            let dataObject = node[JSONKey.data]?.nodeObject,
//            let color = dataObject[JSONKey.color]?.string,
//            let category = dataObject[JSONKey.category]?.string
//            else { throw Abort.badRequest }
//
//        try self.init(color: color, category: category, judgeID: judgeID)
//    }

    init(color: PlayerColor, category: Category, judgeID: String) {
        self.judgeID = judgeID
        self.color = color
        self.category = category
    }

    init?(color: String, category: String, judgeID: String) throws {
        guard
            let playerColor = PlayerColor(rawValue: color),
            let category = ScoringEvent.Category(rawValue: category)
            else {
                return nil
//                throw Abort.badRequest
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

    public var description: String {
        return "[\(color.displayName) \(category.displayName)]"
    }

    public var isPenalty: Bool {
        return category == .gamJeom || category == .kyongGo
    }
}

extension ScoringEvent: Equatable {
    public static func ==(lhs: ScoringEvent, rhs: ScoringEvent) -> Bool {
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

//    init(node: Node) throws {
//        guard
//            let judgeID = node[JSONKey.judgeID]?.string,
//            let dataObject = node[JSONKey.data]?.nodeObject,
//            let categoryRaw = dataObject[JSONKey.category]?.string
//            else { throw Abort.badRequest }
//
//        try self.init(category: categoryRaw, judgeID: judgeID)
//    }

    init(category: Category, judgeID: String) {
        self.category = category
        self.judgeID = judgeID
    }

    init?(category: String, judgeID: String) throws {
        guard let category = ControlEvent.Category(rawValue: category) else {
            return nil
//            throw Abort.badRequest
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

//extension Node {
//    func createEvent() throws -> Event {
//        let eventType = try EventType(value: self["event"]?.string)
//
//        switch eventType {
//        case .scoring:
//            return try ScoringEvent(node: node)
//        case .control:
//            return try ControlEvent(node: node)
//        }
//    }
//}
