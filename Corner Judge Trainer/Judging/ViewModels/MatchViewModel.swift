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
    
    init() {
        redScoreText = Variable(model.redScore.formattedString())
        blueScoreText = Variable(model.blueScore.formattedString())
        
        redPlayerName = Variable(model.redPlayer.displayName)
        bluePlayerName = Variable(model.bluePlayer.displayName)
        
        setupNameUpdates()
    }
    
    private func setupNameUpdates() {
        redPlayerName.asObservable().subscribeNext {
            self.model.redPlayer.name = $0
        } >>> disposeBag
        
        bluePlayerName.asObservable().subscribeNext {
            self.model.bluePlayer.name = $0
        } >>> disposeBag
    }
    
    public func playerScored(playerColor: PlayerColor, scoringEvent: ScoringEvent) {
        // Update model
        model.playerScored(playerColor, scoringEvent: scoringEvent)
        // Update view model with model's new values
        redScoreText.value = model.redScore.formattedString()
        blueScoreText.value = model.blueScore.formattedString()
        print(model.redPlayer.displayName)
    }
}

extension Double {
    func formattedString() -> String {
        return String(Int(self))
    }
}
