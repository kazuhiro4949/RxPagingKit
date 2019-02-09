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
