//
//  JoinMatchViewModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 11/20/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt
import Intrepid

enum MatchOrigin: Int {
    case local, remote

    var isRemote: Bool {
        switch self {
        case .remote:
            return true
        default:
            return false
        }
    }
}

final class JoinMatchViewModel {

    private struct Constants {
        static let matchRefreshInterval = 5.0
    }

    var cellViewModels: Observable<[JoinMatchTableViewCellViewModel]> {
        return switchBetween(
            observable1: remoteMatchViewModels,
            observable2: localMatchViewModels,
            switchObservable: originIsRemote
        )
    }

    let selectedIndex = Variable(0)

    private var originIsRemote: Observable<Bool> {
        return selectedIndex.asObservable()
            .map { MatchOrigin(rawValue: $0)?.isRemote ?? false }
    }

    private var currentMatchOrigin: MatchOrigin {
        return MatchOrigin(rawValue: selectedIndex.value) ?? .local
    }

    private var localMatches = [Match].init(repeating: Match(type: .none), count: 4)
    private var localMatchViewModels: Observable<[JoinMatchTableViewCellViewModel]> {
        return refreshObservable.map { _ in return self.localMatches.map { JoinMatchTableViewCellViewModel(match: $0) } }
    }

    private var remoteMatches = [Match]()
    private var remoteMatchViewModels: Observable<[JoinMatchTableViewCellViewModel]> {
        return refreshObservable.map { isRemote in
            if isRemote {
                self.getRemoteMatches()
            }
            return self.remoteMatches.map { JoinMatchTableViewCellViewModel(match: $0) }
        }
    }

    private var refreshObservable: Observable<Bool> {
        let interval = Observable<Int>.interval(Constants.matchRefreshInterval, scheduler: MainScheduler.instance).startWith(-1)
        return Observable.combineLatest(originIsRemote, interval) { return $0.0 }
    }

    private let disposeBag = DisposeBag()

    init() {
        getRemoteMatches()
    }

    func matchViewModel(for index: Int) -> MatchViewModel {
        let matches = currentMatchOrigin == .local ? localMatches : remoteMatches

        guard index < matches.count else { fatalError("Match index out of bounds") }
        return MatchViewModel(match: matches[index], isRemote: currentMatchOrigin.isRemote)
//        return MatchViewModel(match: matches[index])
    }

    private func getRemoteMatches() {
        CornerAPIClient.shared.getMatches() { result in
            switch result {
            case .success(let matches):
                self.remoteMatches = matches
            case .failure(let error):
                self.remoteMatches = []
                print(error)
            }
        }
    }

    private func switchBetween<T>(observable1: Observable<T>, observable2: Observable<T>, switchObservable: Observable<Bool>) -> Observable<T> {
        let obs1 = observable1.pausable(switchObservable)
        let obs2 = observable2.pausable(switchObservable.map { !$0 })

        return Observable.of(obs1, obs2).merge()
    }
}
