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
    private let webSocket: WebSocket
    private let participantID = String.random(length: 5)
    private let selectedParticipantType = ParticipantType.judge // TODO: Allow user to choose

    let match: Match
    var participantType: ParticipantType? {
        return selectedParticipantType
    }

    weak var delegate: MatchManagerDelegate?

    init(match: Match) {
        self.match = match

        webSocket = WebSocket(url: URL(string: "ws://\(Request.domainBase)match-ws/\(match.id)/")!)
        webSocket.delegate = self
        webSocket.connect()
    }

    func joinMatch() {
        let event = NewParticipantEvent(participantID: participantID, participantType: selectedParticipantType)
        guard let jsonString = event.jsonString else { return }
        webSocket.write(string: jsonString)
    }

    func score(category: ScoringEvent.Category, color: PlayerColor) {
        guard participantType == .judge else { return }
        let scoringEvent = ScoringEvent(judgeID: participantID, category: category, color: color)
        guard let jsonString = scoringEvent.jsonString else { return }
        webSocket.write(string: jsonString)
    }

    func playPause() {
        guard participantType == .operator else { return }
        let playPauseEvent = ControlEvent(operatorID: participantID, category: .playPause)
        guard let jsonString = playPauseEvent.jsonString else { return }
        webSocket.write(string: jsonString)
    }

    func control(category: ControlEvent.Category, color: PlayerColor? = nil, value: Int? = nil) {
        guard participantType == .operator else { return }
        let controlEvent = ControlEvent(operatorID: participantID, category: category, color: color, value: value)
        guard let jsonString = controlEvent.jsonString else { return }
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
        guard let data = text.data(using: .utf8) else { return }

        do {
            let statusUpdate = try decoder.decode(StatusUpdate.self, from: data)
            received(statusUpdate: statusUpdate)
        } catch let error {
            print(error)
        }
    }

    private func received(statusUpdate: StatusUpdate) {
        switch statusUpdate {
        case .score(let red, let blue):
            delegate?.scoreUpdated(redScore: red, blueScore: blue)
        case .penalties(let red, let blue):
            delegate?.penaltiesUpdated(redPenalties: red, bluePenalties: blue)
        case .timer(let displayTime, let scoringDisabled):
            delegate?.timerUpdated(timeString: displayTime)
            delegate?.matchStatusChanged(scoringDisabled: scoringDisabled)
        case .round(let round):
            delegate?.roundChanged(round: round)
        case .won:
            break
        }
    }

}
