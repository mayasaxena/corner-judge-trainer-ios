//
//  MatchViewModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation
import RxSwift

public class MatchViewModel {
    
    let redScoreText: Observable<String>
    let blueScoreText: Observable<String>
    
    private let matchModel: Observable<MatchModel>
    
    init() {
        let model = MatchModel()
        matchModel = Observable.just(model)
        
        redScoreText = matchModel.map { model in
            return "\(Int(model.redScore))"
        }
        
        blueScoreText = matchModel.map { model in
            return "\(Int(model.blueScore))"
        }
    }
    
    public func playerScored(playerColor: PlayerColor, scoringEvent: ScoringEvent) {
        
//        var playerScore: Double
//        var otherPlayerScore: Double
//        if playerColor == .Blue {
//            playerScore = blueScore
//            otherPlayerScore = redScore
//        } else {
//            playerScore = redScore
//            otherPlayerScore = blueScore
//        }
        
//        switch scoringEvent {
//            
//        case .HeadKick:
//            playerScore += 3
//            
//        case .SpinningHeadKick:
//            playerScore += 4
//            
//        case .BodyKick:
//            playerScore += 1
//            
//        case .SpinningBodyKick:
//            playerScore += 3
//            
//        case .KyongGo:
//            otherPlayerScore += 0.5
//            
//        case .GamJeom:
//            otherPlayerScore += 1
//            
//        }
    }

}