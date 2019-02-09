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

extension PagingMenuViewController: HasDelegate {
    public typealias Delegate = PagingMenuViewControllerDelegate
}

class RxPagingMenuViewControllerDelegateProxy: DelegateProxy<PagingMenuViewController, PagingMenuViewControllerDelegate>, DelegateProxyType, PagingMenuViewControllerDelegate {
    
    let (didSelectSubject, didSelect): (PublishSubject<(Int, Int)>, ControlEvent<(Int, Int)>) = {
        let subject = PublishSubject<(Int, Int)>()
        return (subject, ControlEvent<(Int, Int)>(events: subject.asObserver()))
    }()
    
    let (focusViewTransitionedSubject, focusViewTransitioned): (PublishSubject<PagingMenuFocusView>, ControlEvent<PagingMenuFocusView>) = {
        let subject = PublishSubject<PagingMenuFocusView>()
        return (subject, ControlEvent<PagingMenuFocusView>(events: subject.asObserver()))
    }()
    
    let (willAnimateFocusViewSubject, willAnimateFocusView): (PublishSubject<(Int, PagingMenuFocusViewAnimationCoordinator)>, ControlEvent<(Int, PagingMenuFocusViewAnimationCoordinator)>) = {
        let subject = PublishSubject<(Int, PagingMenuFocusViewAnimationCoordinator)>()
        return (subject, ControlEvent<(Int, PagingMenuFocusViewAnimationCoordinator)>(events: subject.asObserver()))
    }()
    
    let (willDisplayCellSubject, willDisplayCell): (PublishSubject<(PagingMenuViewCell, Int)>, ControlEvent<(PagingMenuViewCell, Int)>) = {
        let subject = PublishSubject<(PagingMenuViewCell, Int)>()
        return (subject, ControlEvent<(PagingMenuViewCell, Int)>(events: subject.asObserver()))
    }()
    

    init(pagingMenuViewController: PagingMenuViewController) {
        super.init(parentObject: pagingMenuViewController, delegateProxy: RxPagingMenuViewControllerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxPagingMenuViewControllerDelegateProxy(pagingMenuViewController: $0) }
    }
    
    // MARK:- PagingContentViewControllerDelegate

    func menuViewController(viewController: PagingMenuViewController, focusViewDidEndTransition focusView: PagingMenuFocusView) {
        focusViewTransitionedSubject.onNext(focusView)
    }
    

    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        didSelectSubject.onNext((page, previousPage))
    }
    

    func menuViewController(viewController: PagingMenuViewController, willAnimateFocusViewTo index: Int, with coordinator: PagingMenuFocusViewAnimationCoordinator) {
        willAnimateFocusViewSubject.onNext((index, coordinator))
    }

    func menuViewController(viewController: PagingMenuViewController, willDisplay cell: PagingMenuViewCell, forItemAt index: Int) {
        willDisplayCellSubject.onNext((cell, index))
    }
}
