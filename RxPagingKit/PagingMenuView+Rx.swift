//
//  PagingMenuView+Rx.swift
//  RxPagingKit
//
//  Created by Meng Li on 2019/06/26.
//  Copyright © 2019 Kazuhiro Hayashi. All rights reserved.
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

extension Reactive where Base: PagingMenuView {
    
    public func items<Item, O: ObservableType>
        (_ source: O) ->
        (_ cellFactory: @escaping (PagingMenuView, Int, Item) -> PagingMenuViewCell) -> Disposable
        where O.Element == [(Item, CGFloat)] {
            return { cellFactory in
                let dataSource = RxPagingMenuViewReactiveArrayDataSource<Item>(cellFactory: cellFactory)
                return self.items(dataSource: dataSource)(source)
            }
    }
    
    public func items<Item, Cell: PagingMenuViewCell, O: ObservableType>
        (cellIdentifier: String, cellType: Cell.Type = Cell.self) ->
        (_ source: O) ->
        (_ configureCell: @escaping (Int, Item, Cell) -> Void) -> Disposable
        where O.Element == [(Item, CGFloat)] {
            
            return { source in
                return { configureCell in
                    let dataSource = RxPagingMenuViewReactiveArrayDataSource<Item> { view, index, item in
                        let cell = view.dequeue(with: cellIdentifier) as! Cell
                        configureCell(index, item, cell)
                        return cell
                    }
                    return self.items(dataSource: dataSource)(source)
                }
            }
    }
    
    public func items<DataSource: PagingMenuViewDataSource & RxPagingMenuViewDataSourceType, O: ObservableType>
        (dataSource: DataSource)
        -> (_ source: O) -> Disposable where  O.Element == DataSource.Element {
            RxPagingMenuViewDataSourceProxy.setCurrentDelegate(nil, to: base)
            
            return { [base] source in
                RxPagingMenuViewDataSourceProxy.setCurrentDelegate(dataSource, to: base)
                
                let subscription = source
                    .asObservable()
                    .observeOn(MainScheduler())
                    .catchError { _ in
                        return Observable.empty()
                    }
                    .concat(Observable.never())
                    .takeUntil(base.rx.deallocated)
                    .subscribe { (event) in
                        dataSource.pagingView(base, observedEvent: event)
                }
                
                return Disposables.create { [weak base] in
                    guard let base = base else { return }
                    subscription.dispose()
                    base.layoutIfNeeded()
                    //TODO: - dispose delegate with unregisterDelegate
                    
                    RxPagingMenuViewDataSourceProxy.setCurrentDelegate(nil, to: base)
                }
            }
    }
    
    public var itemSelected: ControlEvent<Int> {
        return menuDelegate.didSelect
    }
    
    public var willAnimateFocusView: ControlEvent<(Int, PagingMenuFocusViewAnimationCoordinator)> {
        return menuDelegate.willAnimateFocusView
    }
    
    public var willDisplayCell: ControlEvent<(PagingMenuViewCell, Int)> {
        return menuDelegate.willDisplayCell
    }
    
    public var scroll: Binder<Int> {
        return Binder(self.base) { menuView, index in
            menuView.scroll(index: index)
        }
    }
    
    private var menuDelegate: RxPagingMenuViewDelegateProxy {
        return RxPagingMenuViewDelegateProxy.proxy(for: base)
    }
    
}
