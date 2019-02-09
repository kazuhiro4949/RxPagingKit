//
//  PagingContentViewController.Rx.swift
//  RxPagingKit
//
//  Created by kahayash on 2019/02/06.
//  Copyright © 2019 Kazuhiro Hayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PagingKit

public extension Reactive where Base: PagingContentViewController {
    public func viewControllers<O: ObservableType>() ->
        (_ source: O) -> Disposable
        where O.E == [UIViewController] {
            
            return { source in
                let dataSource = RxPagingContentViewControllerReactiveArrayDataSource { _, viewController in
                    return viewController
                }
                return self.viewControllers(dataSource: dataSource)(source)
            }
    }
    
    public func viewControllers<O: ObservableType>() -> (_ source: O) ->
        (_ configureVC: @escaping (Int, UIViewController) -> UIViewController) -> Disposable where O.E == [UIViewController] {
            
            return { source in
                return { configureVC in
                    let dataSource = RxPagingContentViewControllerReactiveArrayDataSource { index, viewController in
                        return configureVC(index, viewController)
                    }
                    return self.viewControllers(dataSource: dataSource)(source)
                }
            }
    }
    
    public func viewControllers<DataSource: PagingContentViewControllerDataSource & RxPagingContentViewControllerDataSourceType, O: ObservableType>
        (dataSource: DataSource)
        -> (_ source: O) -> Disposable where  O.E == DataSource.Element {
            RxPagingContentViewControllerDataSourceProxy.setCurrentDelegate(nil, to: base)
            
            return { [base] source in
                RxPagingContentViewControllerDataSourceProxy.setCurrentDelegate(dataSource, to: base)
                
                let subscription = source
                    .asObservable()
                    .observeOn(MainScheduler())
                    .catchError { _ in
                        return Observable.empty()
                    }
                    .concat(Observable.never())
                    .takeUntil(base.rx.deallocated)
                    .subscribe { (event) in
                        dataSource.pagingViewController(base, observedEvent: event)
                    }
                
                return Disposables.create { [weak base] in
                    guard let base = base else { return }
                    subscription.dispose()
                    base.view.layoutIfNeeded()
                    
                    RxPagingContentViewControllerDataSourceProxy.setCurrentDelegate(nil, to: base)
                }
            }
    }
    
    public var didManualScroll: ControlEvent<(Int, CGFloat)> {
        return delegate.didManualScroll
    }
    
    public var willBeginManualScroll: ControlEvent<Int> {
        return delegate.willBeginManualScroll
    }
    
    public var didEndManualScroll: ControlEvent<Int> {
        return delegate.didEndManualScroll
    }
    
    public var willBeginPaging: ControlEvent<(Int, Bool)> {
        return delegate.willBeginPaging
    }
    
    public var willFinishPaging: ControlEvent<(Int, Bool)> {
        return delegate.willFinishPaging
    }
    
    private var delegate: RxPagingContentViewControllerDelegateProxy {
        return RxPagingContentViewControllerDelegateProxy.proxy(for: base)
    }
}
