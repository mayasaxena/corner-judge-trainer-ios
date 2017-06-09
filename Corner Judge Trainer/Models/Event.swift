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

protocol Event: NodeRepresentable {
    var eventType: EventType { get }
    var judgeID: String { get }
    var data: [String : String] { get }

    init?(node: Node)
    init?(judgeID: String, data: [String: String])
}

extension Event {
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

    var jsonString: String? {
        guard
            let node = try? makeNode(),
            let data = try? JSONSerialization.data(withJSONObject: node.any, options: []),
            let nsstring = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            else { return nil }
        return nsstring as String
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            JSONKey.eventType : eventType.rawValue,
            JSONKey.data : data.makeNode(),
            JSONKey.judgeID : judgeID
        ])
    }
}

fileprivate struct JSONKey {
    static let eventType = "event"
    static let judgeID = "sent_by"
    static let data = "data"
    static let category = "category"
    static let color = "color"
    static let time = "time"
    static let scoringDisabled = "scoringDisabled"
    static let round = "round"
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

    var isPenalty: Bool {
        return category == .gamJeom || category == .kyongGo
    }
}

extension ScoringEvent: Equatable {
    static func == (lhs: ScoringEvent, rhs: ScoringEvent) -> Bool {
        return lhs.category == rhs.category && lhs.color == rhs.color
    }
}

// MARK: - ControlEvent

struct ControlEvent: Event {
    enum Category: String {
        case playPause
        case addJudge
        case status
        case endMatch
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

extension Node {
    func createEvent() -> Event? {
        guard let eventType = EventType(value: self[JSONKey.eventType]?.string) else { return nil }

        switch eventType {
        case .scoring:
            return ScoringEvent(node: node)
        case .control:
            return ControlEvent(node: node)
        }
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

private extension String {
    var boolValue: Bool? {
        if self == "true" {
            return true
        } else if self == "false" {
            return false
        } else {
            return nil
        }
    }
}
