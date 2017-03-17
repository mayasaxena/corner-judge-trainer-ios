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

public final class JoinMatchViewModel {

    private struct Constants {
        static let matchRefreshInterval = 0.5
        static let pollingInterval = 15.0
        static let remoteMatchPollingInterval = Int(Constants.pollingInterval / Constants.matchRefreshInterval)
    }

    public var cellViewModels: Observable<[JoinMatchTableViewCellViewModel]> {
        return switchBetween(
            observable1: remoteMatchViewModels,
            observable2: localMatchViewModels,
            switchObservable: originIsRemote
        )
    }

    public let selectedIndex = Variable(0)

    private var originIsRemote: Observable<Bool> {
        return selectedIndex.asObservable()
            .map { MatchOrigin(rawValue: $0)?.isRemote ?? false }
    }

    private var currentMatchOrigin: MatchOrigin {
        return MatchOrigin(rawValue: selectedIndex.value) ?? .local
    }

    private var localMatches = [Match].init(repeating: Match(), count: 4)
    private var localMatchViewModels: Observable<[JoinMatchTableViewCellViewModel]> {
        return Observable<Int>.interval(Constants.matchRefreshInterval, scheduler: MainScheduler.instance).flatMap { interval in
            return self.getLocalMatchViewModels()
        }
    }

    private var remoteMatches = [Match]()
    private var remoteMatchViewModels: Observable<[JoinMatchTableViewCellViewModel]> {
        return Observable<Int>.interval(Constants.matchRefreshInterval, scheduler: MainScheduler.instance).flatMap { interval in
            return self.getRemoteMatchViewModels(at: interval)
        }
    }

    private let disposeBag = DisposeBag()

    func matchViewModel(for index: Int) -> MatchViewModel {
        let matches = currentMatchOrigin == .local ? localMatches : remoteMatches

        guard index < matches.count else { fatalError("Match index out of bounds") }
        return MatchViewModel(match: matches[index])
    }

    private func getRemoteMatchViewModels(at interval: Int) -> Observable<[JoinMatchTableViewCellViewModel]> {
        if interval % Constants.remoteMatchPollingInterval == 0 || remoteMatches.isEmpty {
            return Observable<[JoinMatchTableViewCellViewModel]>.create { [weak self] observer in
                CornerAPIClient.shared.getMatches() { result in
                    switch result {
                    case .success(let matches):
                        self?.remoteMatches = matches
                        observer.onNext(matches.map { JoinMatchTableViewCellViewModel(match: $0) })
                    case .failure(let error):
                        observer.onError(error)
                        print(error)
                    }
                }
                return Disposables.create()
            }
        } else {
            return Observable.from(remoteMatches.map { JoinMatchTableViewCellViewModel(match: $0) })
        }
    }

    private func getLocalMatchViewModels() -> Observable<[JoinMatchTableViewCellViewModel]> {
        return Observable.from(localMatches.map { JoinMatchTableViewCellViewModel(match: $0) })
    }

    private func switchBetween<T>(observable1: Observable<T>, observable2: Observable<T>, switchObservable: Observable<Bool>) -> Observable<T> {
        let obs1 = observable1.pausable(switchObservable)
        let obs2 = observable2.pausable(switchObservable.map { !$0 })

        return Observable.of(obs1, obs2).merge()
    }
}
