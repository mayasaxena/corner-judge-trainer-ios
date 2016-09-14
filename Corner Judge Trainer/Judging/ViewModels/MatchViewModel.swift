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
    
    // Display match
    let redScoreText: Variable<String>
    let blueScoreText: Variable<String>
    
    let redPlayerName: Variable<String>
    let bluePlayerName: Variable<String>
    
    let matchInfoViewHidden = Variable(false)
    
    let timerLabelTextColor = Variable(UIColor.whiteColor())
    let timerLabelText = Variable("0:00")
    
    let penaltyButtonsVisible = Variable(true)
    let disablingViewVisible = Variable(true)
    
    private var timeRemaining = NSTimeInterval()
    private var endTime = NSDate()
    private var timer = NSTimer()
    
    private var isRestRound = false
    let roundLabelHidden = Variable(false)
    let roundLabelText = Variable("R1")
    
    private var round: Int = 1 {
        didSet {
            round = min(round, model.matchType.roundCount)
            roundLabelText.value = "R\(round)"
        }
    }
    
    init() {
        redScoreText = Variable(model.redScore.formattedString)
        blueScoreText = Variable(model.blueScore.formattedString)
        
        redPlayerName = Variable(model.redPlayer.displayName)
        bluePlayerName = Variable(model.bluePlayer.displayName)
        
        setupNameUpdates()
        resetTimer(model.matchType.roundDuration)
        
        matchInfoViewHidden.value = model.matchType == .None
    }
    
    private func setupNameUpdates() {
        redPlayerName.asObservable().subscribeNext {
            self.model.redPlayer.name = $0
        } >>> disposeBag
        
        bluePlayerName.asObservable().subscribeNext {
            self.model.bluePlayer.name = $0
        } >>> disposeBag
    }
    
    private func resetTimer(time: NSTimeInterval) {
        timeRemaining = time
        timerLabelText.value = timeRemaining.formattedTimeString
    }
    
    private func startTimer() {
        endTime = NSDate().dateByAddingTimeInterval(timeRemaining)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
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
        var roundTime: NSTimeInterval
        
        if isRestRound { // set to normal round
            roundTime = model.matchType.roundDuration
            setupNormalRound()
        } else { // set to rest round
            if round == model.matchType.roundCount {
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
        timerLabelTextColor.value = UIColor.whiteColor()
        isRestRound = false
        disablingViewVisible.value = false
        roundLabelHidden.value = true
        round += 1

    }
    
    private func setupRestRound() {
        timerLabelTextColor.value = UIColor.yellowColor()
        isRestRound = true
        disablingViewVisible.value = true
        roundLabelHidden.value = false
        roundLabelText.value = "REST"
    }

    private func endMatch() {
        disablingViewVisible.value = true
        // TODO: Display alert/modal with match stats and option to start new
    }
    
    public func handleMatchInfoViewTapped() {
        if timer.valid {
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
        if timer.valid {
            timer.invalidate()
        }
    }
    
    public func playerScored(playerColor: PlayerColor, scoringEvent: ScoringEvent) {
        model.playerScored(playerColor, scoringEvent: scoringEvent)
        // Update view model with model's new values
        redScoreText.value = model.redScore.formattedString
        blueScoreText.value = model.blueScore.formattedString
    }
}

extension Double {
    var formattedString: String {
        return String(Int(self))
    }
}

extension NSTimeInterval {
    var formattedTimeString: String {
        return String(format: "%d:%02d", Int(self / 60.0),  Int(ceil(self % 60)))
    }
}
