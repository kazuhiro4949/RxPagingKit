//
//  RxPagingMenuViewDataSourceType.swift
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

public protocol RxPagingMenuViewDataSourceType /*: PagingMenuViewDataSource*/ {
    
    associatedtype Element
    
    func pagingView(_ pagingMenuView: PagingMenuView, observedEvent: Event<Element>)
}

class RxPagingMenuViewReactiveArrayDataSource<Item> {

    typealias Element = [(Item, CGFloat)]
    
    typealias CellFactory = (PagingMenuView, Int, Item) -> PagingMenuViewCell
    
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

}

extension RxPagingMenuViewReactiveArrayDataSource: RxPagingMenuViewDataSourceType {
    
    func pagingView(_ pagingMenuView: PagingMenuView, observedEvent: Event<[(Item, CGFloat)]>) {
        Binder(self) { dataSource, elements in
            dataSource.itemModels = elements
            pagingMenuView.reloadData()
        }.on(observedEvent)
    }
    
}

extension RxPagingMenuViewReactiveArrayDataSource: PagingMenuViewDataSource {
    
    func numberOfItemForPagingMenuView() -> Int {
        return itemModels?.count ?? 0
    }
    
    func pagingMenuView(pagingMenuView: PagingMenuView, cellForItemAt index: Int) -> PagingMenuViewCell {
        return cellFactory(pagingMenuView, index, itemModels![index].0)
    }
    
    func pagingMenuView(pagingMenuView: PagingMenuView, widthForItemAt index: Int) -> CGFloat {
        return itemModels![index].1
    }
    
}
