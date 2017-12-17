//
//  StatusUpdateTests.swift
//  CornerJudgeTrainerTests
//
//  Created by Maya Saxena on 12/11/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import XCTest

class StatusUpdateTests: XCTestCase {

    func testScoreUpdate() {
        let red = 6
        let blue = 10
        let mockStatusUpdate = StatusUpdate.score(red: red, blue: blue)

        let statusUpdateData: Data = {
            let statusUpdateDictionary: [String: Any] = [
                "event" : "status",
                "data" : [
                    "score" : [
                        "red" : red,
                        "blue" : blue
                    ]
                ]
            ]

            let data = try? JSONSerialization.data(withJSONObject: statusUpdateDictionary, options: [])
            return data ?? Data()
        }()

        let decoder = JSONDecoder()
        guard let statusUpdate = try? decoder.decode(StatusUpdate.self, from: statusUpdateData) else {
            XCTFail("Could not decode status update")
            return
        }
        XCTAssertEqual(statusUpdate, mockStatusUpdate)
    }

    func testPenaltiesUpdate() {
        let red = 1
        let blue = 5
        let mockStatusUpdate = StatusUpdate.penalties(red: red, blue: blue)

        let statusUpdateData: Data = {
            let statusUpdateDictionary: [String: Any] = [
                "event" : "status",
                "data" : [
                    "penalties" : [
                        "red" : red,
                        "blue" : blue
                    ]
                ]
            ]

            let data = try? JSONSerialization.data(withJSONObject: statusUpdateDictionary, options: [])
            return data ?? Data()
        }()

        let decoder = JSONDecoder()
        guard let statusUpdate = try? decoder.decode(StatusUpdate.self, from: statusUpdateData) else {
            XCTFail("Could not decode status update")
            return
        }
        XCTAssertEqual(statusUpdate, mockStatusUpdate)
    }

    func testTimerUpdate() {
        let displayTime = "1:10"
        let scoringDisabled = false
        let mockStatusUpdate = StatusUpdate.timer(displayTime: displayTime, scoringDisabled: scoringDisabled)

        let statusUpdateData: Data = {
            let statusUpdateDictionary: [String: Any] = [
                "event" : "status",
                "data" : [
                    "timer" : [
                        "display_time" : displayTime,
                        "scoring_disabled" : scoringDisabled
                    ]
                ]
            ]

            let data = try? JSONSerialization.data(withJSONObject: statusUpdateDictionary, options: [])
            return data ?? Data()
        }()

        let decoder = JSONDecoder()
        guard let statusUpdate = try? decoder.decode(StatusUpdate.self, from: statusUpdateData) else {
            XCTFail("Could not decode status update")
            return
        }
        XCTAssertEqual(statusUpdate, mockStatusUpdate)
    }

    func testRoundUpdate() {
        let round = 1
        let mockStatusUpdate = StatusUpdate.round(round: round)

        let statusUpdateData: Data = {
            let statusUpdateDictionary: [String: Any] = [
                "event" : "status",
                "data" : [
                    "round" : round
                ]
            ]

            let data = try? JSONSerialization.data(withJSONObject: statusUpdateDictionary, options: [])
            return data ?? Data()
        }()

        let decoder = JSONDecoder()
        guard let statusUpdate = try? decoder.decode(StatusUpdate.self, from: statusUpdateData) else {
            XCTFail("Could not decode status update")
            return
        }
        XCTAssertEqual(statusUpdate, mockStatusUpdate)
    }

    func testNilRoundUpdate() {
        let round: Int? = nil
        let mockStatusUpdate = StatusUpdate.round(round: round)

        let statusUpdateData: Data = {
            let statusUpdateDictionary: [String: Any] = [
                "event" : "status",
                "data" : [
                    "round" : round
                ]
            ]

            let data = try? JSONSerialization.data(withJSONObject: statusUpdateDictionary, options: [])
            return data ?? Data()
        }()

        let decoder = JSONDecoder()
        guard let statusUpdate = try? decoder.decode(StatusUpdate.self, from: statusUpdateData) else {
            XCTFail("Could not decode status update")
            return
        }
        XCTAssertEqual(statusUpdate, mockStatusUpdate)
    }

    func testWonUpdate() {
        let winningColor = PlayerColor.red
        let mockStatusUpdate = StatusUpdate.won(winningColor: winningColor)

        let statusUpdateData: Data = {
            let statusUpdateDictionary: [String: Any] = [
                "event" : "status",
                "data" : [
                    "winning_player" : winningColor.rawValue
                ]
            ]

            let data = try? JSONSerialization.data(withJSONObject: statusUpdateDictionary, options: [])
            return data ?? Data()
        }()

        let decoder = JSONDecoder()
        guard let statusUpdate = try? decoder.decode(StatusUpdate.self, from: statusUpdateData) else {
            XCTFail("Could not decode status update")
            return
        }
        XCTAssertEqual(statusUpdate, mockStatusUpdate)
    }
}
