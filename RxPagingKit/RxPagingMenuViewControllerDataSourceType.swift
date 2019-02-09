//
//  RxPagingMenuViewControllerDataSourceType.swift
//  RxPagingKit
//
//  Created by kahayash on 2019/02/06.
//  Copyright © 2019 Kazuhiro Hayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PagingKit

public protocol RxPagingMenuViewControllerDataSourceType /*: PagingMenuViewControllerDataSource*/ {
    
    associatedtype Element
    
    func pagingViewController(_ pagingMenuViewController: PagingMenuViewController, observedEvent: Event<Element>)
}

class RxPagingMenuViewControllerReactiveArrayDataSource<Item>: PagingMenuViewControllerDataSource, RxPagingMenuViewControllerDataSourceType {
    typealias Element = [(Item, CGFloat)]
    
    func pagingViewController(_ pagingMenuViewController: PagingMenuViewController, observedEvent: Event<Element>) {
        Binder(self) { dataSource, elements in
            dataSource.itemModels = elements
            pagingMenuViewController.reloadData()
            }.on(observedEvent)
    }
    
    typealias CellFactory = (PagingMenuViewController, Int, Item) -> PagingMenuViewCell
    
    var itemModels: [(Item, CGFloat)]?
    
    func modelAtIndex(_ index: Int) -> (Item, CGFloat)? {
        return itemModels?[index]
    }
    
    func model(at indexPath: IndexPath) throws -> Any {
        precondition(indexPath.section == 0)
        guard let item = itemModels?[indexPath.item] else {
            throw RxCocoaError.itemsNotYetBound(object: self)
        }
        
        return item
    }
    
    let cellFactory: CellFactory
    
    init(cellFactory: @escaping CellFactory) {
        self.cellFactory = cellFactory
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return itemModels![index].1
    }
    
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return itemModels?.count ?? 0
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        return cellFactory(viewController, index, itemModels![index].0)
    }
}
