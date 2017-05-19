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

final class MatchViewModel: MatchManaging, MatchManagerDelegate {
    let matchManager: MatchManager

    let redPlayerName: String
    let bluePlayerName: String

    private typealias ScoreValues = (redScore: Int, redPenalties: Double, blueScore: Int, bluePenalties: Double)

    private let scoring = Variable(ScoreValues(0, 0, 0, 0))

    var redScoreText: Observable<String?> {
        return scoring.asObservable().map { String($0.redScore) }
    }

    var redPenalties: Observable<Double> {
        return scoring.asObservable().map { $0.redPenalties }
    }

    var blueScoreText: Observable<String?> {
        return scoring.asObservable().map { String($0.blueScore) }
    }

    var bluePenalties: Observable<Double> {
        return scoring.asObservable().map { $0.bluePenalties }
    }

    var shouldHideMatchInfo = false

    var timerLabelTextColor: Observable<UIColor> {
        return scoringDisabled.asObservable().map { $0 ? UIColor.yellow : UIColor.flatWhite}
    }

    private let timerLabelTextVar = Variable<String?>("0:00")
    var timerLabelText: Observable<String?> {
        return timerLabelTextVar.asObservable()
    }

    var disablingViewHidden: Observable<Bool> {
        return scoringDisabled.asObservable().not()
    }

    var roundLabelHidden: Observable<Bool> {
        return scoringDisabled.asObservable().not()
    }

    var navigationBarHidden: Observable<Bool> {
        return scoringDisabled.asObservable().map { !$0 && self.matchManager.match.type != .none }
    }

    private let scoringDisabled = Variable(true)
    private let round = Variable<Int?>(1)

    var roundLabelText: Observable<String?> {
        return round.asObservable().map { round in
            if let round = round {
                return "R\(round)"
            } else {
                return "REST"
            }
        }
    }

    private let disposeBag = DisposeBag()

    init(match: Match, isRemote: Bool = false) {
        redPlayerName = match.redPlayer.displayName
        bluePlayerName = match.bluePlayer.displayName

        matchManager = isRemote ? RemoteMatchManager(match: match) : LocalMatchManager(match: match)
        matchManager.delegate = self
        shouldHideMatchInfo = match.type == .none
        scoringDisabled.value = match.type != .none
    }

    func handleMatchInfoViewTapped() {
        matchManager.playPause()
    }

    // MARK: - View Handlers

    func handleScoringAreaTapped(color: PlayerColor) {
        matchManager.handle(scoringEvent: ScoringEvent(judgeID: "judge-iOS", category: .head, color: color))
    }

    func handleScoringAreaSwiped(color: PlayerColor) {
        matchManager.handle(scoringEvent: ScoringEvent(judgeID: "judge-iOS", category: .body, color: color))
    }

    func handleTechnicalButtonTapped(color: PlayerColor) {
        matchManager.handle(scoringEvent: ScoringEvent(judgeID: "judge-iOS", category: .technical, color: color))
    }

    func handlePenaltyConfirmed(color: PlayerColor, penalty: ScoringEvent.Category) {
        matchManager.handle(scoringEvent: ScoringEvent(judgeID: "judge-iOS", category: penalty, color: color))
    }

    // MARK: - MatchManagerDelegate

    func scoreUpdated(
        redScore: Double,
        redPenalties: Double,
        blueScore: Double,
        bluePenalties: Double
    ) {
        scoring.value = ScoreValues(Int(redScore), redPenalties, Int(blueScore), bluePenalties)
        // TODO: Penalties
    }

    func timerUpdated(timeString: String) {
        timerLabelTextVar.value = timeString
    }

    func matchStatusChanged(scoringDisabled: Bool) {
        self.scoringDisabled.value = scoringDisabled
    }

    func roundChanged(round: Int?) {
        self.round.value = round
    }
}

extension Double {
    var formattedString: String {
        return String(Int(self))
    }
}
