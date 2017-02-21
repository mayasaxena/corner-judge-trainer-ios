//
//  Rx+Extensions.swift
//  SwiftWisdom
//
//  Created by Logan Wright on 3/31/16.
//  Copyright © 2016 Intrepid. All rights reserved.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func subscribeNext(_ on: @escaping (E) -> Swift.Void) -> Disposable {
        return subscribe(onNext: on)
    }
}

precedencegroup Binding {
    associativity: left
    higherThan: Disposing
    lowerThan: AssignmentPrecedence
}

precedencegroup Disposing {
    associativity: left
}

infix operator <- : Binding
infix operator <-> : Binding

public func <- <O: UIBindingObserver<UILabel, String?>>(observer: O, observable: Variable<String>) -> Disposable {
    return observable.asObservable().bindTo(observer)
}


public func <-> <T>(property: ControlProperty<T?>, variable: Variable<T>) -> Disposable {
    let bindToUIDisposable = variable
        .asObservable()
        .bindTo(property)
    let bindToVariable = property
        .subscribe(
            onNext: { n in
                guard let n = n else { return }
                variable.value = n
        },
            onCompleted:  {
                bindToUIDisposable.dispose()
        }
    )

    return Disposables.create(bindToUIDisposable, bindToVariable)
}
