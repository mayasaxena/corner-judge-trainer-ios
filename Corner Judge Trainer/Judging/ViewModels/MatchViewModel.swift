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


public class MatchViewModel {
    
    let redScoreText: Variable<String>
    let blueScoreText: Variable<String>
    
    let redPlayerName: Variable<String>
    let bluePlayerName: Variable<String>
    
    private let matchModel: MatchModel
    
    private let disposeBag = DisposeBag()
    
    init() {
        matchModel = MatchModel()
        
        // Set current value to model's value
        redScoreText = Variable(matchModel.redScore.formattedString())
        blueScoreText = Variable(matchModel.blueScore.formattedString())
        redPlayerName = Variable(matchModel.redPlayer.name)
        bluePlayerName = Variable(matchModel.bluePlayer.name)
    }
    
    public func playerScored(playerColor: PlayerColor, scoringEvent: ScoringEvent) {
        // Update model
        matchModel.playerScored(playerColor, scoringEvent: scoringEvent)
        // Update view model with model's new values
        redScoreText.value = matchModel.redScore.formattedString()
        blueScoreText.value = matchModel.blueScore.formattedString()
    }
    
    public func addPlayerNames(redPlayerName: String?, bluePlayerName: String?) {
        if let redPlayerName = redPlayerName {
            self.redPlayerName.value = redPlayerName
        }
        
        if let bluePlayerName = bluePlayerName {
            self.bluePlayerName.value = bluePlayerName
        }
    }
}

extension Double {
    func formattedString() -> String {
        return String(Int(self))
    }
}
