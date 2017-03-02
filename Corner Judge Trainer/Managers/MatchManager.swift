//
//  MatchManager.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 2/28/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation

internal protocol MatchManagerDelegate: class {

    func scoreUpdated(
        redScore: Double,
        redPenalties: Double,
        blueScore: Double,
        bluePenalties: Double
    )

    func timerUpdated(timeString: String)
    func matchStatusChanged(scoringDisabled: Bool)
    func roundChanged(round: Int?)
}

internal protocol MatchManager: class {
    var match: Match { get }
    weak var delegate: MatchManagerDelegate? { get set }

    func handle(scoringEvent: ScoringEvent)
    func joinMatch()
    func playPause()
}

internal protocol MatchManaging: MatchManagerDelegate {
    var matchManager: MatchManager { get }
}
