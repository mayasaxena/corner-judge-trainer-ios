//
//  RemoteMatch.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 2/23/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation
import Starscream

final class RemoteMatchManager: MatchManager, WebSocketDelegate {

    let match: Match
    weak var delegate: MatchManagerDelegate?

    private var webSocket: WebSocket

    init(match: Match) {
        self.match = match

        webSocket = WebSocket(url: URL(string: "ws://\(Request.domainBase)match-ws/\(match.id)/")!)
        webSocket.delegate = self
        webSocket.connect()
    }

    func handle(scoringEvent: ScoringEvent) {
        guard let jsonString = scoringEvent.jsonString else { return }
        webSocket.write(string: jsonString)
    }

    func joinMatch() {
        webSocket.write(string: "{\"event\":\"newJudge\",\"sent_by\":\"test-app\",\"data\":{}}")
    }

    func playPause() {
        let playPauseEvent = ControlEvent(operatorID: "test-app", category: .playPause)
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

        let decoder = JSONDecoder()
        guard
            let data = text.data(using: .utf8)
//            let event = node.createEvent()
            else { return }
//        received(event: event)

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

    // TODO: BAD! Match shouldn't be handling events itself - duplication
    func handleScoringUpdateReceived(scoringEvent: ScoringEvent) {
        match.handle(scoringEvent: scoringEvent)
        delegate?.scoreUpdated(redScore: match.redScore, blueScore: match.blueScore)
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
        case .giveGamJeom:
            guard let color = controlEvent.color else { return }
            match.giveGamJeom(to: color)
            delegate?.penaltiesUpdated(redPenalties: match.redPenalties, bluePenalties: match.bluePenalties)
        case .removeGamJeom:
            guard let color = controlEvent.color else { return }
            match.removeGamJeom(from: color)
            delegate?.penaltiesUpdated(redPenalties: match.redPenalties, bluePenalties: match.bluePenalties)
        case .adjustScore:
            guard
                let color = controlEvent.color,
                let amount = controlEvent.value
                else { return }
            match.adjustScore(for: color, byAmount: amount)
            delegate?.scoreUpdated(redScore: match.redScore, blueScore: match.blueScore)
        default:
            break
        }
    }
}

extension Match {
    func giveGamJeom(to color: PlayerColor) {
        switch color {
        case .blue:
            bluePenalties += 1
            redScore += 1
        case .red:
            redPenalties += 1
            blueScore += 1
        }
    }

    func removeGamJeom(from color: PlayerColor) {
        switch color {
        case .blue:
            guard bluePenalties > 0 else { return }
            bluePenalties -= 1
            redScore -= 1
        case .red:
            guard redPenalties > 0 else { return }
            redPenalties -= 1
            blueScore -= 1
        }
    }

    func adjustScore(for color: PlayerColor, byAmount amount: Int) {
        switch color {
        case .blue:
            if blueScore + amount >= 0 {
                blueScore += amount
            }
        case .red:
            if redScore + amount >= 0 {
                redScore += amount
            }
        }
    }
}

extension Match {

//        let matchID: Int = try map.extract(NodeKey.matchID)
//        // Not reporting match type in JSON yet
//        let matchType = try map.extract(NodeKey.matchType) { MatchType(rawValue: $0) ?? MatchType.none }
//
//        let redPlayer: String = try map.extract(NodeKey.redName)
//        let bluePlayer: String = try map.extract(NodeKey.blueName)
//
//        let redScore: Int = try map.extract(NodeKey.redScore)
//        let redPenalties: Int = try map.extract(NodeKey.redGamJeomCount)
//
//        let blueScore: Int = try map.extract(NodeKey.blueScore)
//        let bluePenalties: Int = try map.extract(NodeKey.blueGamJeomCount)
//
//        self.init(
//            id: matchID,
//            redPlayerName: redPlayer,
//            bluePlayerName: bluePlayer,
//            type: matchType,
//            redScore: redScore,
//            redPenalties: redPenalties,
//            blueScore: blueScore,
//            bluePenalties: bluePenalties
//        )
//    }
}

private struct NodeKey {
    static let matchID = "match-id"
    static let matchType = "match-type"
    static let date = "date"
    static let redName = "red-player"
    static let redScore = "red-score"
    static let redGamJeomCount = "red-gamjeom-count"
    static let blueName = "blue-player"
    static let blueScore = "blue-score"
    static let blueGamJeomCount = "blue-gamjeom-count"
    static let round = "round"
    static let blueScoreClass = "blue-score-class"
    static let redScoreClass = "red-score-class"
    static let time = "time"
    static let overlayVisible = "overlay-visible"
    static let status = "status"
}
