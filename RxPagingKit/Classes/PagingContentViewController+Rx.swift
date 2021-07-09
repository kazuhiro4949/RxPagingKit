//
//  PagingContentViewController+Rx.swift
//  PagingKit
//
//  Copyright (c) 2017 Kazuhiro Hayashi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import RxSwift
import RxCocoa
import PagingKit

extension Reactive where Base: PagingContentViewController {
    
    public func viewControllers<O: ObservableType>() ->
        (_ source: O) -> Disposable
        where O.Element == [UIViewController] {
            
            return { source in
                let dataSource = RxPagingContentViewControllerReactiveArrayDataSource { _, viewController in
                    return viewController
                }
                return self.viewControllers(dataSource: dataSource)(source)
            }
    }
    
    public func viewControllers<O: ObservableType>() -> (_ source: O) ->
        (_ configureVC: @escaping (Int, UIViewController) -> UIViewController) -> Disposable where O.Element == [UIViewController] {
            
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
        -> (_ source: O) -> Disposable where  O.Element == DataSource.Element {
            RxPagingContentViewControllerDataSourceProxy.setCurrentDelegate(nil, to: base)
            
            return { [base] source in
                RxPagingContentViewControllerDataSourceProxy.setCurrentDelegate(dataSource, to: base)
                
                let subscription = source
                    .asObservable()
                    .observe(on: MainScheduler())
                    .catch { _ in
                        return Observable.empty()
                    }
                    .concat(Observable.never())
                    .take(until: base.rx.deallocated)
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
    
    public var didFinishPaging: ControlEvent<(Int, Bool)> {
        return delegate.didFinishPaging
    }
    
    public func scroll(animated: Bool) -> Binder<Int> {
        return Binder(self.base) { (controller, index) in
            controller.scroll(to: index, animated: animated)
        }
    }
    
    private var delegate: RxPagingContentViewControllerDelegateProxy {
        return RxPagingContentViewControllerDelegateProxy.proxy(for: base)
    }
    
}
