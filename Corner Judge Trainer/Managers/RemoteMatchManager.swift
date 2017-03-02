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

public final class RemoteMatchManager: MatchManager, MappableObject, WebSocketDelegate {

    let match: Match
    weak var delegate: MatchManagerDelegate?

    private var webSocket: WebSocket

    public init(map: Map) throws {
        match = try Match(map: map)

        webSocket = WebSocket(url: URL(string: "ws://localhost:8080/match/10/")!)
        webSocket.delegate = self
        webSocket.connect()
    }

    public func handle(scoringEvent: ScoringEvent) {}
    public func joinMatch() {}
    public func playPause() {}

    // MARK: - WebSocketDelegate

    public func websocketDidConnect(socket: WebSocket) {}
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {}
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {}
    public func websocketDidReceiveData(socket: WebSocket, data: Data) {}
}

extension Match: MappableObject {

    public convenience init(map: Map) throws {
        let matchID: Int = try map.extract(NodeKey.matchID)
        let matchType = try map.extract(NodeKey.matchType) { MatchType(rawValue: $0) ?? MatchType.none }

        let redPlayer: String = try map.extract(NodeKey.redName)
        let bluePlayer: String = try map.extract(NodeKey.blueName)

        self.init(id: matchID, redPlayerName: redPlayer, bluePlayerName: bluePlayer, type: matchType)

        redScore = try map.extract(NodeKey.redScore)

        let redKyonggos: Double = try map.extract(NodeKey.redKyongGoCount)
        let redGamJeoms: Double = try map.extract(NodeKey.redGamJeomCount)
        redPenalties = redGamJeoms + (redKyonggos / 2)
        blueScore = try map.extract(NodeKey.blueScore)

        let blueKyonggos: Double = try map.extract(NodeKey.blueKyongGoCount)
        let blueGamJeoms: Double = try map.extract(NodeKey.blueGamJeomCount)
        bluePenalties = blueGamJeoms + (blueKyonggos / 2)
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
}
