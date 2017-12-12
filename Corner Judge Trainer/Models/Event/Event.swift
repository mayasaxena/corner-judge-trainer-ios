//
//  Event.swift
//  corner-judge-trainer-ios
//
//  Created by Maya Saxena on 12/25/16.
//
//

import Foundation

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
    case control, scoring, newParticipant
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
    var participantID: String { get }
}

extension Event {
    var jsonString: String? {
        return ""
    }
}

struct NewParticipantEvent: Event {

    enum ParticipantType: String {
        case judge
        case `operator`
        case viewer
    }

    let eventType = EventType.newParticipant
    let participantID: String
    let participantType: ParticipantType

    init(participantID: String, participantType: ParticipantType) {
        self.participantID = participantID
        self.participantType = participantType
    }

    init() {
        participantID = String.random(length: 5)
        participantType = .judge
    }

    func encode(to encoder: Encoder) throws {
    }
}

//extension Node {
//    func createEvent() -> Event? {
//        guard let eventType = EventType(value: self[JSONKey.eventType]?.string) else { return nil }
//
//        switch eventType {
//        case .scoring:
//            return ScoringEvent(node: node)
//        case .control:
//            return ControlEvent(node: node)
//        default:
//            return nil
//        }
//    }
//}

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

    static func random(length: Int) -> String {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyz0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
}
