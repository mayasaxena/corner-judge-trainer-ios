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

public final class MatchViewModel {
    private let model = MatchModel.sharedModel
    private let disposeBag = DisposeBag()
    
    let redScoreText: Variable<String?>
    let blueScoreText: Variable<String>
    
    let redPlayerName: Variable<String>
    let bluePlayerName: Variable<String>
    
    let matchInfoViewHidden = Variable(false)
    
    let timerLabelTextColor = Variable(UIColor.white)
    let timerLabelText = Variable("0:00")
    
    let penaltyButtonsVisible = Variable(true)
    let disablingViewVisible = Variable(true)

    private var timeRemaining = TimeInterval()
    private var endTime = Date()
    private var timer = Timer()

    let matchHasEnded = Variable(false)
    private var matchEnded = false {
        didSet {
            matchHasEnded.value = matchEnded
        }
    }
    
    let roundLabelHidden = Variable(false)
    let roundLabelText = Variable("R1")
    private var isRestRound = false

    init() {
        redScoreText = Variable(model.redScore.formattedString)
        blueScoreText = Variable(model.blueScore.formattedString)
        
        redPlayerName = Variable(model.redPlayer.displayName)
        bluePlayerName = Variable(model.bluePlayer.displayName)
        
        setupNameUpdates()
        
        resetTimer(model.matchType.roundDuration)
        
        matchInfoViewHidden.value = model.matchType == .none
    }
    
    private func setupNameUpdates() {
        redPlayerName.asObservable().subscribe(onNext: {
            self.model.redPlayer.name = $0
        }) >>> disposeBag
        
        bluePlayerName.asObservable().subscribe(onNext: {
            self.model.bluePlayer.name = $0
        }) >>> disposeBag
    }
    
    private func resetTimer(_ time: TimeInterval) {
        timeRemaining = time
        timerLabelText.value = timeRemaining.formattedTimeString
    }
    
    private func startTimer() {
        endTime = Date().addingTimeInterval(timeRemaining)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    dynamic func updateTime() {
        if timeRemaining > 0 {
            timeRemaining = endTime.timeIntervalSinceNow
            timerLabelText.value = timeRemaining.formattedTimeString
        } else {
            timer.invalidate()
            timerLabelText.value = "0:00"
            endRound()
        }
    }
    
    private func endRound() {
        var roundTime: TimeInterval
        
        if isRestRound { // set to normal round
            roundTime = model.matchType.roundDuration
            setupNormalRound()
        } else { // set to rest round
            if model.round == model.matchType.roundCount {
                endMatch()
                return
            } else {
                roundTime = model.restTimeInterval
                setupRestRound()
            }
        }
        resetTimer(roundTime)
        startTimer()
    }
    
    private func setupNormalRound() {
        timerLabelTextColor.value = UIColor.white
        isRestRound = false
        disablingViewVisible.value = false
        roundLabelHidden.value = true
        model.round += 1
        roundLabelText.value = "R\(model.round)"
    }
    
    private func setupRestRound() {
        timerLabelTextColor.value = UIColor.yellow
        isRestRound = true
        disablingViewVisible.value = true
        roundLabelHidden.value = false
        roundLabelText.value = "REST"
    }

    private func endMatch() {
        print(model.winningPlayer?.name)
        pauseTimer()
        disablingViewVisible.value = true
        matchEnded = true
        // TODO: Display alert/modal with match stats and option to start new
    }
    
    public func handleMatchInfoViewTapped() {
        guard !matchEnded else { return }
        if timer.isValid {
            pauseTimer()
            penaltyButtonsVisible.value = true
            roundLabelHidden.value = false
            disablingViewVisible.value = true
            
        } else {
            startTimer()
            penaltyButtonsVisible.value = false
            if !isRestRound {
                roundLabelHidden.value = true
                disablingViewVisible.value = false
            }
        }
    }
    
    public func pauseTimer() {
        if timer.isValid {
            timer.invalidate()
        }
    }

    // MARK: - View Handlers

    public func handleScoringAreaTapped(color: PlayerColor) {
        playerScored(playerColor: color, scoringEvent: .head)
    }

    public func handleScoringAreaSwiped(color: PlayerColor) {
        playerScored(playerColor: color, scoringEvent: .body)
    }

    public func handleTechnicalButtonTapped(color: PlayerColor) {
        playerScored(playerColor: color, scoringEvent: .technical)
    }

    public func handlePenaltyConfirmed(color: PlayerColor, penalty: ScoringEvent) {
        playerScored(playerColor: color, scoringEvent: penalty)
    }

    private func playerScored(playerColor: PlayerColor, scoringEvent: ScoringEvent) {
        model.updateScore(playerColor: playerColor, scoringEvent: scoringEvent)

        redScoreText.value = model.redScore.formattedString
        blueScoreText.value = model.blueScore.formattedString

        if model.winningPlayer != nil {
            endMatch()
        }
    }
}

extension Double {
    var formattedString: String {
        return String(Int(self))
    }
}

extension TimeInterval {
    var formattedTimeString: String {
        return String(format: "%d:%02d", Int(self / 60.0),  Int(ceil(self.truncatingRemainder(dividingBy: 60))))
    }
}
