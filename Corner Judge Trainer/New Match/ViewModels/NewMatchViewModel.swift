//
//  NewMatchViewModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 8/27/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import RxSwift
import Intrepid

public final class NewMatchViewModel {
    private let disposeBag = DisposeBag()
    
    // Create match
    var radioButtonsSelected: [Variable<Bool>] = []
    
    let model = Match.current
    
    init() {
        for _ in 0 ..< MatchType.caseCount {
            radioButtonsSelected.append(Variable(false))
        }
        
        setRadioButtonSelected(atIndex: model.matchType.rawValue)
    }
    
    public func setRadioButtonSelected(atIndex index: Int) {
        for (i, radioButtonSelected) in radioButtonsSelected.enumerated() {
            if i == index {
                radioButtonSelected.value = true
                model.matchType = MatchType(rawValue: index) ?? .none
            } else {
                radioButtonSelected.value = false
            }
        }
    }
}
