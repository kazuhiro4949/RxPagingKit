//
//  PagingMenuViewDelegateProxy.swift
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

/// Describes an object that has a delegate.
public protocol HasMenuDelegate: AnyObject {
    /// Delegate type
    associatedtype MenuDelegate
    
    /// Delegate
    var menuDelegate: MenuDelegate? { get set }
}

extension DelegateProxyType where ParentObject: HasMenuDelegate, Self.Delegate == ParentObject.MenuDelegate {
    public static func currentDelegate(for object: ParentObject) -> Delegate? {
        return object.menuDelegate
    }
    
    public static func setCurrentDelegate(_ delegate: Delegate?, to object: ParentObject) {
        object.menuDelegate = delegate
    }
}

extension PagingMenuView: HasMenuDelegate {
    public typealias MenuDelegate = PagingMenuViewDelegate
}

class RxPagingMenuViewDelegateProxy: DelegateProxy<PagingMenuView, PagingMenuViewDelegate> { //<PagingMenuView, PagingMenuViewDelegate> {

    let (didSelectSubject, didSelect): (PublishSubject<Int>, ControlEvent<Int>) = {
        let subject = PublishSubject<Int>()
        return (subject, ControlEvent<Int>(events: subject.asObserver()))
    }()
    
    let (willAnimateFocusViewSubject, willAnimateFocusView): (PublishSubject<(Int, PagingMenuFocusViewAnimationCoordinator)>, ControlEvent<(Int, PagingMenuFocusViewAnimationCoordinator)>) = {
        let subject = PublishSubject<(Int, PagingMenuFocusViewAnimationCoordinator)>()
        return (subject, ControlEvent<(Int, PagingMenuFocusViewAnimationCoordinator)>(events: subject.asObserver()))
    }()
    
    let (willDisplayCellSubject, willDisplayCell): (PublishSubject<(PagingMenuViewCell, Int)>, ControlEvent<(PagingMenuViewCell, Int)>) = {
        let subject = PublishSubject<(PagingMenuViewCell, Int)>()
        return (subject, ControlEvent<(PagingMenuViewCell, Int)>(events: subject.asObserver()))
    }()
    
    static func registerKnownImplementations() {
        self.register(make: { RxPagingMenuViewDelegateProxy(pagingMenuView: $0) })
    }
    
    init(pagingMenuView: PagingMenuView) {
        super.init(parentObject: pagingMenuView, delegateProxy: RxPagingMenuViewDelegateProxy.self)
    }
    
}

extension RxPagingMenuViewDelegateProxy: DelegateProxyType {}

extension RxPagingMenuViewDelegateProxy: PagingMenuViewDelegate {
    
    func pagingMenuView(pagingMenuView: PagingMenuView, didSelectItemAt index: Int) {
        didSelectSubject.onNext(index)
    }
    
    func pagingMenuView(pagingMenuView: PagingMenuView, willAnimateFocusViewTo index: Int, with coordinator: PagingMenuFocusViewAnimationCoordinator) {
        willAnimateFocusViewSubject.onNext((index, coordinator))
    }
    
    func pagingMenuView(pagingMenuView: PagingMenuView, willDisplay cell: PagingMenuViewCell, forItemAt index: Int) {
        willDisplayCellSubject.onNext((cell, index))
    }

}
