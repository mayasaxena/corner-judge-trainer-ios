//
//  Event.swift
//  corner-judge-trainer-ios
//
//  Created by Maya Saxena on 12/25/16.
//
//

import Foundation
import Genome

struct JSONKey {
    static let eventType = "event"
    static let judgeID = "sent_by"
    static let data = "data"
    static let category = "category"
    static let color = "color"
    static let time = "time"
    static let scoringDisabled = "scoringDisabled"
    static let round = "round"
    static let value = "value"
}

enum EventType: String {
    case control, scoring, newJudge
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

struct NewJudgeEvent: Event {
    init(judgeID: String, data: [String : String]) {
        self.judgeID = judgeID
    }

    let eventType = EventType.newJudge
    var judgeID: String
    let data: [String : String] = [:]
}

extension Node {
    func createEvent() -> Event? {
        guard let eventType = EventType(value: self[JSONKey.eventType]?.string) else { return nil }

        switch eventType {
        case .scoring:
            return ScoringEvent(node: node)
        case .control:
            return ControlEvent(node: node)
        default:
            return nil
        }
    }
}

extension String {
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
