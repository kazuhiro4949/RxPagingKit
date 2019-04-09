//
//  PagingKitProxy.swift
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

extension Reactive where Base: PagingMenuViewController {
    
    public func items<Item, O: ObservableType>
        (_ source: O) ->
        (_ cellFactory: @escaping (PagingMenuViewController, Int, Item) -> PagingMenuViewCell) -> Disposable
        where O.E == [(Item, CGFloat)] {
            return { cellFactory in
                let dataSource = RxPagingMenuViewControllerReactiveArrayDataSource<Item>(cellFactory: cellFactory)
                return self.items(dataSource: dataSource)(source)
            }
    }
    
    public func items<Item, Cell: PagingMenuViewCell, O: ObservableType>
        (cellIdentifier: String, cellType: Cell.Type = Cell.self) ->
        (_ source: O) ->
        (_ configureCell: @escaping (Int, Item, Cell) -> Void) -> Disposable
        where O.E == [(Item, CGFloat)] {
            
            return { source in
                return { configureCell in
                    let dataSource = RxPagingMenuViewControllerReactiveArrayDataSource<Item> { vc, index, item in
                        let cell = vc.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: index) as! Cell
                        configureCell(index, item, cell)
                        return cell
                    }
                    return self.items(dataSource: dataSource)(source)
                }
            }
    }
    
    public func items<DataSource: PagingMenuViewControllerDataSource & RxPagingMenuViewControllerDataSourceType, O: ObservableType>
        (dataSource: DataSource)
        -> (_ source: O) -> Disposable where  O.E == DataSource.Element {
            RxPagingMenuViewControllerDataSourceProxy.setCurrentDelegate(nil, to: base)
            
            return { [base] source in
                RxPagingMenuViewControllerDataSourceProxy.setCurrentDelegate(dataSource, to: base)
                
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
                    //TODO: - dispose delegate with unregisterDelegate
                    
                    RxPagingMenuViewControllerDataSourceProxy.setCurrentDelegate(nil, to: base)
                }
            }
    }
    
    public var itemSelected: ControlEvent<(Int, Int)> {
        return delegate.didSelect
    }
    
    public var focusViewTransitioned: ControlEvent<PagingMenuFocusView> {
        return delegate.focusViewTransitioned
    }

    public var willAnimateFocusView: ControlEvent<(Int, PagingMenuFocusViewAnimationCoordinator)> {
        return delegate.willAnimateFocusView
    }

    public var willDisplayCell: ControlEvent<(PagingMenuViewCell, Int)> {
        return delegate.willDisplayCell
    }
    
    public var scroll: Binder<Int> {
        return Binder(self.base) { (controller, index) in
            controller.scroll(index: index)
        }
    }
    
    private var delegate: RxPagingMenuViewControllerDelegateProxy {
        return RxPagingMenuViewControllerDelegateProxy.proxy(for: base)
    }
    
}
