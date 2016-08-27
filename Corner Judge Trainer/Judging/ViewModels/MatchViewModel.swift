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
    private let matchModel: MatchModel
    private let disposeBag = DisposeBag()
    
    let redScoreText: Variable<String>
    let blueScoreText: Variable<String>
    
    let redPlayerName: Variable<String>
    let bluePlayerName: Variable<String>
    
    var radioButtonsSelected: [Variable<Bool>] = []
    
    init() {
        matchModel = MatchModel()
        
        // Set current value to model's value
        redScoreText = Variable(matchModel.redScore.formattedString())
        blueScoreText = Variable(matchModel.blueScore.formattedString())
        
        redPlayerName = Variable(matchModel.redPlayer.displayName)
        bluePlayerName = Variable(matchModel.bluePlayer.displayName)
        
        redPlayerName.asObservable().subscribeNext {
            self.matchModel.redPlayer.name = $0
        } >>> disposeBag
        
        bluePlayerName.asObservable().subscribeNext {
            self.matchModel.bluePlayer.name = $0
        } >>> disposeBag
        
        for _ in 0 ..< MatchType.caseCount {
            radioButtonsSelected.append(Variable(false))
        }
        
        setRadioButtonSelected(atIndex: matchModel.matchType.rawValue)
    }
    
    public func setRadioButtonSelected(atIndex index: Int) {
        for (i, radioButtonSelected) in radioButtonsSelected.enumerate() {
            if i == index {
                radioButtonSelected.value = true
                matchModel.matchType = MatchType(rawValue: index) ?? .None
            } else {
                radioButtonSelected.value = false
            }
        }
    }
    
    public func playerScored(playerColor: PlayerColor, scoringEvent: ScoringEvent) {
        // Update model
        matchModel.playerScored(playerColor, scoringEvent: scoringEvent)
        // Update view model with model's new values
        redScoreText.value = matchModel.redScore.formattedString()
        blueScoreText.value = matchModel.blueScore.formattedString()
    }
}

extension Double {
    func formattedString() -> String {
        return String(Int(self))
    }
}
