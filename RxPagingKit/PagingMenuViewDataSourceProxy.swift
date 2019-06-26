//
//  PagingMenuViewDataSourceProxy.swift
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

extension PagingMenuView: HasDataSource {
    public typealias DataSource = PagingMenuViewDataSource
}

class RxPagingMenuViewDataSourceProxy: DelegateProxy<PagingMenuView, PagingMenuViewDataSource>, DelegateProxyType, PagingMenuViewDataSource {

    init(pagingMenuView: PagingMenuView) {
        super.init(parentObject: pagingMenuView, delegateProxy: RxPagingMenuViewDataSourceProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxPagingMenuViewDataSourceProxy(pagingMenuView: $0) }
    }
    
    func numberOfItemForPagingMenuView() -> Int {
        return forwardToDelegate()!.numberOfItemForPagingMenuView()
    }
    
    func pagingMenuView(pagingMenuView: PagingMenuView, cellForItemAt index: Int) -> PagingMenuViewCell {
        return forwardToDelegate()!.pagingMenuView(pagingMenuView: pagingMenuView, cellForItemAt: index)
    }
    
    func pagingMenuView(pagingMenuView: PagingMenuView, widthForItemAt index: Int) -> CGFloat {
        return forwardToDelegate()!.pagingMenuView(pagingMenuView: pagingMenuView, widthForItemAt: index)
    }
    
}
