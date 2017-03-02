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

    let redPlayerName = Variable<String?>(nil)
    let bluePlayerName = Variable<String?>(nil)

    var radioButtonsSelected: [Variable<Bool>] = []

    private let disposeBag = DisposeBag()

    var newMatch: Match {
        return Match(redPlayerName: redPlayerName.value, bluePlayerName: bluePlayerName.value, type: matchType)
    }

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
