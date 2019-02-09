//
//  PagingMenuViewControllerDataSourceProxy.swift
//  RxPagingKit
//
//  Created by kahayash on 2019/02/06.
//  Copyright © 2019 Kazuhiro Hayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PagingKit

extension PagingMenuViewController: HasDataSource {
    public typealias DataSource = PagingMenuViewControllerDataSource
}

class RxPagingMenuViewControllerDataSourceProxy: DelegateProxy<PagingMenuViewController, PagingMenuViewControllerDataSource>, DelegateProxyType, PagingMenuViewControllerDataSource {
    init(pagingMenuViewController: PagingMenuViewController) {
        super.init(parentObject: pagingMenuViewController, delegateProxy: RxPagingMenuViewControllerDataSourceProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxPagingMenuViewControllerDataSourceProxy(pagingMenuViewController: $0) }
    }
    
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return forwardToDelegate()?.numberOfItemsForMenuViewController(viewController: viewController) ?? 0
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        return forwardToDelegate()!.menuViewController(viewController: viewController, cellForItemAt: index)
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return forwardToDelegate()!.menuViewController(viewController: viewController, widthForItemAt: index)
    }
}
