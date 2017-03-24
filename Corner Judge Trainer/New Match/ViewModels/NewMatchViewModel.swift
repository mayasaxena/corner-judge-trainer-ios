//
//  NewMatchViewModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 8/27/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import RxSwift
import Intrepid

final class NewMatchViewModel {
    var matchType = MatchType.none

    let redPlayerName = Variable("")
    let bluePlayerName = Variable("")

    var radioButtonsSelected: [Observable<Bool>] {
        return buttonsSelected.map { $0.asObservable() }
    }

    private var buttonsSelected = [Variable<Bool>]()

    private let disposeBag = DisposeBag()

    var matchViewModel: MatchViewModel {
        let match = Match(redPlayerName: redPlayerName.value, bluePlayerName: bluePlayerName.value, type: matchType)
        return MatchViewModel(match: match)
    }

    init() {
        for _ in 0 ..< MatchType.caseCount {
            buttonsSelected.append(Variable(false))
        }
        
        setRadioButtonSelected(atIndex: matchType.rawValue)
    }
    
    func setRadioButtonSelected(atIndex index: Int) {
        for (i, radioButtonSelected) in buttonsSelected.enumerated() {
            if i == index {
                radioButtonSelected.value = true
                matchType = MatchType(rawValue: index) ?? .none
            } else {
                radioButtonSelected.value = false
            }
        }
    }
}
