//
//  PagingContentViewControllerDataSourceProxy.swift
//  RxPagingKit
//
//  Created by kahayash on 2019/02/09.
//  Copyright © 2019 Kazuhiro Hayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PagingKit

extension PagingContentViewController: HasDataSource {
    public typealias DataSource = PagingContentViewControllerDataSource
}

class RxPagingContentViewControllerDataSourceProxy: DelegateProxy<PagingContentViewController, PagingContentViewControllerDataSource>, DelegateProxyType, PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return forwardToDelegate()?.numberOfItemsForContentViewController(viewController: viewController) ?? 0
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return forwardToDelegate()!.contentViewController(viewController: viewController, viewControllerAt: index)
    }
    
    init(pagingContentViewController: PagingContentViewController) {
        super.init(parentObject: pagingContentViewController, delegateProxy: RxPagingContentViewControllerDataSourceProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxPagingContentViewControllerDataSourceProxy(pagingContentViewController: $0) }
    }
}
