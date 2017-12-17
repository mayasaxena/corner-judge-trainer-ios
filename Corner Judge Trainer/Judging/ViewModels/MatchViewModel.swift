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

    // TODO: Better names
    private typealias ScoreValues = (redScore: Int, blueScore: Int)
    private typealias PenaltyValues = (redPenalties: Int, bluePenalties: Int)

    private let scores: Variable<ScoreValues>
    private let penalties: Variable<PenaltyValues>

    var shouldHideMatchInfo = false

    var shouldShowControls: Bool {
        return matchManager.participantType == nil || matchManager.participantType == .operator
    }

    var shouldAllowScoring: Bool {
        return matchManager.participantType == nil || matchManager.participantType == .judge
    }

    var redScoreText: Observable<String?> {
        return scores.asObservable().map { String($0.redScore) }
    }

    var redPenalties: Observable<Int> {
        return penalties.asObservable().map { $0.redPenalties }
    }

    var blueScoreText: Observable<String?> {
        return scores.asObservable().map { String($0.blueScore) }
    }

    var bluePenalties: Observable<Int> {
        return penalties.asObservable().map { $0.bluePenalties }
    }

    var timerLabelTextColor: Observable<UIColor> {
        return scoringDisabled.asObservable().map { $0 ? UIColor.yellow : UIColor.flatWhite}
    }

    private let timerLabelTextVariable = Variable<String?>("0:00")
    var timerLabelText: Observable<String?> {
        return timerLabelTextVariable.asObservable()
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
        shouldHideMatchInfo = match.type == .none
        scoringDisabled.value = match.type != .none

        scores = Variable(ScoreValues(redScore: match.redScore, blueScore: match.blueScore))
        penalties = Variable(PenaltyValues(redPenalties: match.redPenalties, bluePenalties: match.bluePenalties))

        matchManager.delegate = self
    }

    func handleMatchInfoViewTapped() {
        matchManager.playPause()
    }

    // MARK: - View Handlers

    func handleScoringAreaTapped(color: PlayerColor) {
        matchManager.score(category: .head, color: color)
    }

    func handleScoringAreaSwiped(color: PlayerColor) {
        matchManager.score(category: .body, color: color)
    }

    func handleTechnicalButtonTapped(color: PlayerColor) {
        matchManager.score(category: .technical, color: color)
    }

    func handlePenaltyConfirmed(color: PlayerColor, penalty: ControlEvent.Category) {
        matchManager.control(category: penalty, color: color, value: nil)
    }

    // MARK: - MatchManagerDelegate

    func scoreUpdated(redScore: Int, blueScore: Int) {
        scores.value = ScoreValues(redScore, blueScore)
    }

    func penaltiesUpdated(redPenalties: Int, bluePenalties: Int) {
        penalties.value = PenaltyValues(redPenalties, bluePenalties)
    }

    func timerUpdated(timeString: String) {
        timerLabelTextVariable.value = timeString
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
