//
//  MatchViewModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation
import RxSwift
import Intrepid

public final class MatchViewModel: MatchManaging, MatchManagerDelegate {
    let matchManager: MatchManager

    let redPlayerName: String
    let bluePlayerName: String
    
    let redScoreText = Variable<String?>("0")
    let blueScoreText = Variable<String?>("0")

    let matchInfoViewHidden = Variable(false)
    
    let timerLabelTextColor = Variable(UIColor.white)
    let timerLabelText: Variable<String?> = Variable("0:00")
    
    let penaltyButtonsVisible = Variable(true)
    let disablingViewVisible = Variable(true)

    let roundLabelHidden = Variable(false)
    let roundLabelText: Variable<String?> = Variable("R1")

    private let disposeBag = DisposeBag()

    init(match: Match) {
        matchManager = LocalMatchManager(match: match)
        
        redPlayerName = match.redPlayer.displayName
        bluePlayerName = match.bluePlayer.displayName

        matchManager.delegate = self
        matchInfoViewHidden.value = match.type == .none
    }
    
    public func handleMatchInfoViewTapped() {
        matchManager.playPause()
    }
    
    // MARK: - View Handlers

    public func handleScoringAreaTapped(color: PlayerColor) {
        matchManager.handle(scoringEvent: ScoringEvent(color: color, category: .head, judgeID: "judge-iOS"))
    }

    public func handleScoringAreaSwiped(color: PlayerColor) {
        matchManager.handle(scoringEvent: ScoringEvent(color: color, category: .body, judgeID: "judge-iOS"))
    }

    public func handleTechnicalButtonTapped(color: PlayerColor) {
        matchManager.handle(scoringEvent: ScoringEvent(color: color, category: .technical, judgeID: "judge-iOS"))
    }

    public func handlePenaltyConfirmed(color: PlayerColor, penalty: ScoringEvent.Category) {
        matchManager.handle(scoringEvent: ScoringEvent(color: color, category: penalty, judgeID: "judge-iOS"))
    }

    // MARK: - MatchManagerDelegate

    func scoreUpdated(
        redScore: Double,
        redPenalties: Double,
        blueScore: Double,
        bluePenalties: Double
    ) {
        redScoreText.value = redScore.formattedString
        blueScoreText.value = blueScore.formattedString

        // TODO: Penalties
    }

    func timerUpdated(timeString: String) {
        timerLabelText.value = timeString
    }

    func matchStatusChanged(scoringDisabled: Bool) {
        disablingViewVisible.value = scoringDisabled
        penaltyButtonsVisible.value = scoringDisabled
        roundLabelHidden.value = !scoringDisabled
    }

    func roundChanged(round: Int?) {
        if let round = round {
            timerLabelTextColor.value = UIColor.white
            disablingViewVisible.value = false
            roundLabelHidden.value = true
            roundLabelText.value = "R\(round)"
        } else {
            timerLabelTextColor.value = UIColor.yellow
            disablingViewVisible.value = true
            roundLabelHidden.value = false
            roundLabelText.value = "REST"
        }
    }
}

extension Double {
    var formattedString: String {
        return String(Int(self))
    }
}
