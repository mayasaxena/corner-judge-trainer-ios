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
    
    let timerLabelText = Variable("0:00")
    let matchInfoViewHidden = Variable(false)
    let roundLabelText = Variable("R1")
    
    private var timer = NSTimer()
    private var timeRemaining = NSTimeInterval()
    private var endTime = NSDate()
    
    init() {
        redScoreText = Variable(model.redScore.formattedString)
        blueScoreText = Variable(model.blueScore.formattedString)
        
        redPlayerName = Variable(model.redPlayer.displayName)
        bluePlayerName = Variable(model.bluePlayer.displayName)
        
        setupNameUpdates()
        resetTimer(model.matchType.roundDuration)
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
    
    dynamic func updateTime() {
        if timeRemaining > 0 {
            timeRemaining = endTime.timeIntervalSinceNow
            timerLabelText.value = timeRemaining.formattedTimeString
        } else {
            timer.invalidate()
            timerLabelText.value = "0:00"
        }
    }
    
    public func startTimer() {
        endTime = NSDate().dateByAddingTimeInterval(timeRemaining)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    public func playerScored(playerColor: PlayerColor, scoringEvent: ScoringEvent) {
        // Update model
        model.playerScored(playerColor, scoringEvent: scoringEvent)
        // Update view model with model's new values
        redScoreText.value = model.redScore.formattedString
        blueScoreText.value = model.blueScore.formattedString
        print(model.redPlayer.displayName)
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
