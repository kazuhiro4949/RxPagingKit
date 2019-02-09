//
//  PagingMenuViewController+Rx.swift
//  RxPagingKit
//
//  Created by kahayash on 2019/02/06.
//  Copyright © 2019 Kazuhiro Hayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PagingKit

public extension Reactive where Base: PagingMenuViewController {
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
    
    private var delegate: RxPagingMenuViewControllerDelegateProxy {
        return RxPagingMenuViewControllerDelegateProxy.proxy(for: base)
    }
}



