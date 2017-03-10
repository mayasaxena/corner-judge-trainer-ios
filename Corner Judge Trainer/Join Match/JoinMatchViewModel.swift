//
//  JoinMatchViewModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 11/20/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation
import RxSwift

public final class JoinMatchViewModel {

    public var cellViewModels = Observable.just([JoinMatchTableViewCellViewModel]())
    private var matches = [Match]()

    init() {
       cellViewModels = Observable<[JoinMatchTableViewCellViewModel]>.create { [weak self] observer in
            CornerAPIClient.shared.getMatches() { result in
                switch result {
                case .success(let matches):
                    self?.matches = matches
                    observer.onNext(matches.map { JoinMatchTableViewCellViewModel(match: $0) })
                case .failure(let error):
                    observer.onError(error)
                    print(error)
                }
            }

            return Disposables.create()
        }
    }

    func matchViewModel(for index: Int) -> MatchViewModel {
        guard index < matches.count else { fatalError("Match index out of bounds") }
        return MatchViewModel(match: matches[index])
    }
}
