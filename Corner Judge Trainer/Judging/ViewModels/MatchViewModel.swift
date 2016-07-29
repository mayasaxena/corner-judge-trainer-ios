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
    private(set) var redScore = Variable("0")
    private(set) var blueScore = Variable("0")
    
    public func redHeadshot() {
        addHeadshotTo(redScore)
    }
    
    public func blueHeadshot() {
        addHeadshotTo(blueScore)
    }
    
    private func addHeadshotTo(playerScore: Variable<Int>) {
        playerScore.value += 3
    }
    

}