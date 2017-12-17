//
//  MatchManager.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 2/28/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation

protocol MatchManagerDelegate: class {

    func scoreUpdated(redScore: Int, blueScore: Int)
    func penaltiesUpdated(redPenalties: Int, bluePenalties: Int)
    func timerUpdated(timeString: String)
    func matchStatusChanged(scoringDisabled: Bool)
    func roundChanged(round: Int?)
}

protocol MatchManager: class {
    var match: Match { get }
    var participantType: ParticipantType? { get } // Nil for local manager, can do everything
    weak var delegate: MatchManagerDelegate? { get set }

    func joinMatch()
    func playPause()
    func score(category: ScoringEvent.Category, color: PlayerColor)
    func control(category: ControlEvent.Category, color: PlayerColor?, value: Int?)
}

protocol MatchManaging: MatchManagerDelegate {
    var matchManager: MatchManager { get }
}
