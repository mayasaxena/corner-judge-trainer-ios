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
    public var matchType = MatchType.none

    var radioButtonsSelected: [Variable<Bool>] = []

    private let disposeBag = DisposeBag()

    init() {

        for _ in 0 ..< MatchType.caseCount {
            radioButtonsSelected.append(Variable(false))
        }
        
        setRadioButtonSelected(atIndex: matchType.rawValue)
    }
    
    public func setRadioButtonSelected(atIndex index: Int) {
        for (i, radioButtonSelected) in radioButtonsSelected.enumerated() {
            if i == index {
                radioButtonSelected.value = true
                matchType = MatchType(rawValue: index) ?? .none
            } else {
                radioButtonSelected.value = false
            }
        }
    }
}
