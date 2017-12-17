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
     guard let jsonString = NewParticipantEvent().jsonString else { return }
        webSocket.write(string: jsonString)
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
        case .won(let winningColor):
            break
        }
    }

}
