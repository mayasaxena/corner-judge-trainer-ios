//
//  Event.swift
//  corner-judge-trainer-ios
//
//  Created by Maya Saxena on 12/25/16.
//
//

import Foundation

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

enum EventCodingKey: String, CodingKey {
    case eventType = "event"
    case participantID = "sent_by"
    case data
    case category
    case color
    case time
    case scoringDisabled = "scoring_disabled"
    case round
    case value
    case participantType = "participant_type"
}

protocol Event: Encodable {
    var eventType: EventType { get }
    var participantID: String { get }
}

extension Event {
    var jsonString: String? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)
        } catch let error {
            print(error)
            return nil
        }
    }
}

enum ParticipantType: String {
    case judge
    case `operator`
    case viewer
}

struct NewParticipantEvent: Event {

    let eventType = EventType.newParticipant
    let participantID: String
    let participantType: ParticipantType

    init(participantID: String = String.random(length: 5), participantType: ParticipantType = .judge) {
        self.participantID = participantID
        self.participantType = participantType
    }

    enum TypeCodingKey: String, CodingKey {
        case participantType = "participant_type"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EventCodingKey.self)
        try container.encode(eventType.rawValue, forKey: .eventType)
        try container.encode(participantID, forKey: .participantID)
        var dataContainer = container.nestedContainer(keyedBy: TypeCodingKey.self, forKey: .data)
        try dataContainer.encode(participantType.rawValue, forKey: .participantType)
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
