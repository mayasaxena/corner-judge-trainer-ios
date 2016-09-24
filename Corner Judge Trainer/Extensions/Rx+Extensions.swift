//
//  Rx+Extensions.swift
//  SwiftWisdom
//
//  Created by Logan Wright on 3/31/16.
//  Copyright © 2016 Intrepid. All rights reserved.
//

import RxSwift
import RxCocoa

precedencegroup DisposePrecedence {}

precedencegroup BindPrecedence {
    higherThan: DisposePrecedence
}

infix operator <-> : BindPrecedence
infix operator <- : BindPrecedence
infix operator <-+ : BindPrecedence
infix operator <-* : BindPrecedence

infix operator >>> : DisposePrecedence

public func <- <T>(property: AnyObserver<T>, variable: Observable<T>) -> Disposable {
    return variable
        .map { $0 }
        .observeOn(MainScheduler.instance)
        .bindTo(property)
}

public func <-* <T>(property: AnyObserver<T>, variable: Variable<T>) -> Disposable {
    return property <- variable.asObservable()
}

public func <-+ <T>(variable: Variable<T>, property: ControlProperty<T>) -> Disposable {
    return property.subscribe(onNext: { variable.value = $0 })
}

public func >>> (disposable: Disposable, disposeBag: DisposeBag) {
    return disposeBag.insert(disposable)
}

public func >>> (disposable: Disposable, compositeDisposable: CompositeDisposable) -> CompositeDisposable.DisposeKey? {
    return compositeDisposable.insert(disposable)
}

//  Operators.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//  https://github.com/ReactiveX/RxSwift/blob/master/RxExample/RxExample/Operators.swift
public func <-> <T>(property: ControlProperty<T>, variable: Variable<T>) -> Disposable {
    let bindToUIDisposable = variable
        .asObservable()
        .bindTo(property)
    let bindToVariable = property
        .subscribe(
            onNext: { n in
                variable.value = n
            },
            onCompleted:  {
                bindToUIDisposable.dispose()
            }
    )
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}
