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
        redScoreText = Variable(matchModel.redScore.restrictedString())
        blueScoreText = Variable(matchModel.blueScore.restrictedString())
        redPlayerName = Variable(matchModel.redPlayer.name)
        bluePlayerName = Variable(matchModel.bluePlayer.name)
        
        // Update model when score text changes
        redScoreText.asObservable().subscribeNext { scoreText in
            self.matchModel.redScore = Double(scoreText) ?? 0
        } >>> disposeBag
        
        blueScoreText.asObservable().subscribeNext { scoreText in
            self.matchModel.blueScore = Double(scoreText) ?? 0
        } >>> disposeBag
        
        redPlayerName.asObservable().subscribeNext { name in
            self.matchModel.redPlayer.name = name
        } >>> disposeBag
        
        bluePlayerName.asObservable().subscribeNext { name in
            self.matchModel.bluePlayer.name = name
        } >>> disposeBag
    }
    
    public func playerScored(playerColor: PlayerColor, scoringEvent: ScoringEvent) {
        var playerScore = 0.0
        var otherPlayerScore = 0.0
        
        switch scoringEvent {
            
        case .Head:
            playerScore += 3
            
        case .Body:
            playerScore += 1
            
        case .Technical:
            playerScore += 1
            
        // TODO: Fix so # of kyonggos increase instead
        case .KyongGo:
            otherPlayerScore += 0.5
            
        case .GamJeom:
            otherPlayerScore += 1
        }
        
        let blueScore = Double(blueScoreText.value) ?? 0
        let redScore = Double(redScoreText.value) ?? 0
        
        if playerColor == .Blue {
            blueScoreText.value = (blueScore + playerScore).restrictedString()
            redScoreText.value = (redScore + otherPlayerScore).restrictedString()
        } else {
            redScoreText.value = (redScore + playerScore).restrictedString()
            blueScoreText.value = (blueScore + otherPlayerScore).restrictedString()
        }
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
    func restrictedString() -> String {
        let maxScore = 99.0
        return String(Int(floor(min(self, maxScore))))
    }
}
