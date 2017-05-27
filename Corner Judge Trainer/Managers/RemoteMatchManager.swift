//
//  RemoteMatch.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 2/23/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation
import Genome
import Starscream

final class RemoteMatchManager: MatchManager, WebSocketDelegate {

    let match: Match
    weak var delegate: MatchManagerDelegate?

    private var webSocket: WebSocket

    init(match: Match) {
        self.match = match

//        webSocket = WebSocket(url: URL(string: "ws://corner-judge.herokuapp.com/match-ws/\(match.id)/")!)
        webSocket = WebSocket(url: URL(string: "ws://localhost:8080/match-ws/\(match.id)/")!)
        webSocket.delegate = self
        webSocket.connect()
    }

    func handle(scoringEvent: ScoringEvent) {
        guard let jsonString = scoringEvent.jsonString else { return }
        webSocket.write(string: jsonString)
    }

    func joinMatch() {
        webSocket.write(string: "{\"event\":\"control\",\"sent_by\":\"test-app\",\"data\":{\"category\":\"addJudge\"}}")
    }

    func playPause() {
        let playPauseEvent = ControlEvent(judgeID: "test-app", category: .playPause)
        guard let jsonString = playPauseEvent.jsonString else { return }
        webSocket.write(string: jsonString)
    }

    // MARK: - WebSocketDelegate

    func websocketDidConnect(socket: WebSocket) {
        joinMatch()
    }

    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {}
    func websocketDidReceiveData(socket: WebSocket, data: Data) {}

    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print(text)

        guard
            let data = text.data(using: .utf8),
            let node = try? data.makeNode(),
            let event = node.createEvent()
            else { return }
        received(event: event)

    }

    private func received(event: Event) {
        switch event {
        case let scoringEvent as ScoringEvent:
            handleScoringUpdateReceived(scoringEvent: scoringEvent)
        case let controlEvent as ControlEvent:
            handleReceived(controlEvent: controlEvent)
        default:
            break
        }
    }

    func handleScoringUpdateReceived(scoringEvent: ScoringEvent) {
        match.handle(scoringEvent: scoringEvent)

        delegate?.scoreUpdated(
            redScore: match.redScore,
            redPenalties: match.redPenalties,
            blueScore: match.blueScore,
            bluePenalties: match.bluePenalties
        )
    }

    private func handleReceived(controlEvent: ControlEvent) {
        switch controlEvent.category {
        case .status:
            if let time = controlEvent.time {
                delegate?.timerUpdated(timeString: time)
            }
            if let scoringDisabled = controlEvent.scoringDisabled {
                delegate?.matchStatusChanged(scoringDisabled: scoringDisabled)
            }
            delegate?.roundChanged(round: controlEvent.round)
        default:
            break
        }
    }
}

extension Match: MappableObject {

    convenience init(map: Map) throws {
        let matchID: Int = try map.extract(NodeKey.matchID)
        // Not reporting match type in JSON yet
        let matchType = try map.extract(NodeKey.matchType) { MatchType(rawValue: $0) ?? MatchType.none }

        let redPlayer: String = try map.extract(NodeKey.redName)
        let bluePlayer: String = try map.extract(NodeKey.blueName)

        let redScore: Double = try map.extract(NodeKey.redScore)

        let redKyonggos: Double = try map.extract(NodeKey.redKyongGoCount)
        let redGamJeoms: Double = try map.extract(NodeKey.redGamJeomCount)
        let redPenalties = redGamJeoms + (redKyonggos / 2)
        let blueScore: Double = try map.extract(NodeKey.blueScore)

        let blueKyonggos: Double = try map.extract(NodeKey.blueKyongGoCount)
        let blueGamJeoms: Double = try map.extract(NodeKey.blueGamJeomCount)
        let bluePenalties = blueGamJeoms + (blueKyonggos / 2)

        self.init(
            id: matchID,
            redPlayerName: redPlayer,
            bluePlayerName: bluePlayer,
            type: matchType,
            redScore: redScore,
            redPenalties: redPenalties,
            blueScore: blueScore,
            bluePenalties: bluePenalties
        )
    }
}

fileprivate struct NodeKey {
    static let matchID = "match-id"
    static let matchType = "match-type"
    static let date = "date"
    static let redName = "red-player"
    static let redScore = "red-score"
    static let redGamJeomCount = "red-gamjeom-count"
    static let redKyongGoCount = "red-kyonggo-count"
    static let blueName = "blue-player"
    static let blueScore = "blue-score"
    static let blueGamJeomCount = "blue-gamjeom-count"
    static let blueKyongGoCount = "blue-kyonggo-count"
    static let round = "round"
    static let blueScoreClass = "blue-score-class"
    static let redScoreClass = "red-score-class"
    static let time = "time"
    static let overlayVisible = "overlay-visible"
    static let status = "status"
}
