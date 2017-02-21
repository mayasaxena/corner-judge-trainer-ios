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
    let model: Match

    var radioButtonsSelected: [Variable<Bool>] = []

    private let disposeBag = DisposeBag()

    init(model: Match = Match()) {
        self.model = model

        for _ in 0 ..< MatchType.caseCount {
            radioButtonsSelected.append(Variable(false))
        }
        
        setRadioButtonSelected(atIndex: MatchType.none.rawValue)
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
