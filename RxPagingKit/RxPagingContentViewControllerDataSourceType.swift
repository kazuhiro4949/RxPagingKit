//
//  RxPagingContentViewControllerDataSourceType.swift
//  RxPagingKit
//
//  Created by kahayash on 2019/02/09.
//  Copyright © 2019 Kazuhiro Hayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PagingKit

public protocol RxPagingContentViewControllerDataSourceType /*: PagingContentViewControllerDataSource*/ {
    
    associatedtype Element
    
    func pagingViewController(_ pagingMenuViewController: PagingContentViewController, observedEvent: Event<Element>)
}

public class RxPagingContentViewControllerReactiveArrayDataSource: PagingContentViewControllerDataSource, RxPagingContentViewControllerDataSourceType {
    public func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return itemModels?.count ?? 0
        
    }
    
    public func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return vcFactory(index, itemModels![index])
        
    }
    
    public func pagingViewController(_ pagingMenuViewController: PagingContentViewController, observedEvent: Event<[UIViewController]>) {
        Binder(self) { dataSource, elements in
            dataSource.itemModels = elements
            pagingMenuViewController.reloadData()
            }.on(observedEvent)
    }
    
    public typealias Element = [UIViewController]
    
    public typealias VCFactory = (Int, UIViewController) -> UIViewController
    
    var itemModels: [UIViewController]?
    
    public func modelAtIndex(_ index: Int) -> UIViewController? {
        return itemModels?[index]
    }
    
    public func model(at indexPath: IndexPath) throws -> Any {
        precondition(indexPath.section == 0)
        guard let item = itemModels?[indexPath.item] else {
            throw RxCocoaError.itemsNotYetBound(object: self)
        }
        
        return item
    }
    
    let vcFactory: VCFactory
    
    public init(vcFactory: @escaping VCFactory) {
        self.vcFactory = vcFactory
    }
}
