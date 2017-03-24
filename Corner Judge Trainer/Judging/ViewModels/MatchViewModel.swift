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

    private let redScoreTextVar = Variable<String?>("0")
    var redScoreText: Observable<String?> {
        return redScoreTextVar.asObservable()
    }

    private let blueScoreTextVar = Variable<String?>("0")
    var blueScoreText: Observable<String?> {
        return blueScoreTextVar.asObservable()
    }

    private let matchInfoViewHiddenVar = Variable(false)
    var matchInfoViewHidden: Observable<Bool> {
        return matchInfoViewHiddenVar.asObservable()
    }

    var timerLabelTextColor: Observable<UIColor> {
        return scoringDisabled.asObservable().map { $0 ? UIColor.yellow : UIColor.flatWhite}
    }

    private let timerLabelTextVar = Variable<String?>("0:00")
    var timerLabelText: Observable<String?> {
        return timerLabelTextVar.asObservable()
    }

    var penaltyButtonsVisible: Observable<Bool> {
        return scoringDisabled.asObservable()
    }

    var disablingViewVisible: Observable<Bool> {
        return scoringDisabled.asObservable()
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
        matchInfoViewHiddenVar.value = match.type == .none
        scoringDisabled.value = match.type != .none

        matchManager.joinMatch()
    }
    
    func handleMatchInfoViewTapped() {
        matchManager.playPause()
    }
    
    // MARK: - View Handlers

    func handleScoringAreaTapped(color: PlayerColor) {
        matchManager.handle(scoringEvent: ScoringEvent(color: color, category: .head, judgeID: "judge-iOS"))
    }

    func handleScoringAreaSwiped(color: PlayerColor) {
        matchManager.handle(scoringEvent: ScoringEvent(color: color, category: .body, judgeID: "judge-iOS"))
    }

    func handleTechnicalButtonTapped(color: PlayerColor) {
        matchManager.handle(scoringEvent: ScoringEvent(color: color, category: .technical, judgeID: "judge-iOS"))
    }

    func handlePenaltyConfirmed(color: PlayerColor, penalty: ScoringEvent.Category) {
        matchManager.handle(scoringEvent: ScoringEvent(color: color, category: penalty, judgeID: "judge-iOS"))
    }

    // MARK: - MatchManagerDelegate

    func scoreUpdated(
        redScore: Double,
        redPenalties: Double,
        blueScore: Double,
        bluePenalties: Double
    ) {
        redScoreTextVar.value = redScore.formattedString
        blueScoreTextVar.value = blueScore.formattedString

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
