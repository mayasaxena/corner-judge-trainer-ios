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

    private var match: Match {
        return matchManager.match
    }

    private let disposeBag = DisposeBag()
    
    let redScoreText = Variable<String?>("0")
    let blueScoreText = Variable<String?>("0")
    
    let redPlayerName = Variable("")
    let bluePlayerName = Variable("")

    let matchInfoViewHidden = Variable(false)
    
    let timerLabelTextColor = Variable(UIColor.white)
    let timerLabelText: Variable<String?> = Variable("0:00")
    
    let penaltyButtonsVisible = Variable(true)
    let disablingViewVisible = Variable(true)

    let roundLabelHidden = Variable(false)
    let roundLabelText: Variable<String?> = Variable("R1")

    init(matchType: MatchType) {
        matchManager = LocalMatchManager(matchType: matchType)
        matchManager.delegate = self

        redScoreText.value = match.redScore.formattedString
        blueScoreText.value = match.blueScore.formattedString
        
        redPlayerName.value = match.redPlayer.displayName
        bluePlayerName.value = match.bluePlayer.displayName

        setupNameUpdates()

        matchInfoViewHidden.value = match.type == .none
    }
    
    private func setupNameUpdates() {
//        redPlayerName.asObservable().subscribeNext {
//            self.model.redPlayer.name = $0
//        } >>> disposeBag
//        
//        bluePlayerName.asObservable().subscribeNext {
//            self.model.bluePlayer.name = $0
//        } >>> disposeBag
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

    func timerStatusChanged(paused: Bool) {
        disablingViewVisible.value = paused
        penaltyButtonsVisible.value = paused
        roundLabelHidden.value = !paused
    }

    func roundChanged(isRestRound: Bool, round: Int?) {
        if isRestRound {
            timerLabelTextColor.value = UIColor.yellow
            disablingViewVisible.value = true
            roundLabelHidden.value = false
            roundLabelText.value = "REST"
        } else {
            guard let round = round else { return }
            timerLabelTextColor.value = UIColor.white
            disablingViewVisible.value = false
            roundLabelHidden.value = true
            roundLabelText.value = "R\(round)"
        }
    }
}

extension Double {
    var formattedString: String {
        return String(Int(self))
    }
}
