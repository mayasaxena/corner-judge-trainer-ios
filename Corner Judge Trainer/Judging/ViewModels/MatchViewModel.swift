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
    
    private let matchModel: MatchModel
    
    private let disposeBag = DisposeBag()
    
    init() {
        matchModel = MatchModel()
        
        // Set current value to model's value
        redScoreText = Variable(matchModel.redScore.flooredString())
        blueScoreText = Variable(matchModel.blueScore.flooredString())
        
        // Update model when score text changes
        redScoreText.asObservable().subscribeNext { scoreText in
            self.matchModel.redScore = Double(scoreText) ?? 0
        } >>> disposeBag
        
        blueScoreText.asObservable().subscribeNext { scoreText in
            self.matchModel.blueScore = Double(scoreText) ?? 0
        } >>> disposeBag

    }
    
    public func playerScored(playerColor: PlayerColor, scoringEvent: ScoringEvent) {
        var playerScore = 0.0
        var otherPlayerScore = 0.0
        
        switch scoringEvent {
            
        case .HeadKick:
            playerScore += 3
            
        case .SpinningHeadKick:
            playerScore += 4
            
        case .BodyKick:
            playerScore += 1
            
        case .SpinningBodyKick:
            playerScore += 3
            
        case .KyongGo:
            otherPlayerScore += 0.5
            
        case .GamJeom:
            otherPlayerScore += 1
            
        }
        
        let blueScore = Double(blueScoreText.value) ?? 0
        let redScore = Double(redScoreText.value) ?? 0
        
        if playerColor == .Blue {
            blueScoreText.value = (blueScore + playerScore).flooredString()
            redScoreText.value = (redScore + otherPlayerScore).flooredString()
        } else {
            redScoreText.value = (redScore + playerScore).flooredString()
            blueScoreText.value = (blueScore + otherPlayerScore).flooredString()
        }
    }

}

extension Double {
    func flooredString() -> String {
        return String(Int(floor(self)))
    }
}
