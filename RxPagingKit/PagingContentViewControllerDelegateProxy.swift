//
//  PagingContentViewControllerDelegateProxy.swift
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

extension PagingContentViewController: HasDelegate {
    public typealias Delegate = PagingContentViewControllerDelegate
}

class RxPagingContentViewControllerDelegateProxy: DelegateProxy<PagingContentViewController, PagingContentViewControllerDelegate>, DelegateProxyType, PagingContentViewControllerDelegate {
    
    let (didManualScrollSubject, didManualScroll): (PublishSubject<(Int, CGFloat)>, ControlEvent<(Int, CGFloat)>) = {
        let subject = PublishSubject<(Int, CGFloat)>()
        return (subject, ControlEvent<(Int, CGFloat)>(events: subject.asObserver()))
    }()
    
    let (willBeginManualScrollSubject, willBeginManualScroll): (PublishSubject<Int>, ControlEvent<Int>) = {
        let subject = PublishSubject<Int>()
        return (subject, ControlEvent<Int>(events: subject.asObserver()))
    }()
    
    let (didEndManualScrollSubject, didEndManualScroll): (PublishSubject<Int>, ControlEvent<Int>) = {
        let subject = PublishSubject<Int>()
        return (subject, ControlEvent<Int>(events: subject.asObserver()))
    }()
    
    let (willBeginPagingSubject, willBeginPaging): (PublishSubject<(Int, Bool)>, ControlEvent<(Int, Bool)>) = {
        let subject = PublishSubject<(Int, Bool)>()
        return (subject, ControlEvent<(Int, Bool)>(events: subject.asObserver()))
    }()
    
    let (willFinishPagingSubject, willFinishPaging): (PublishSubject<(Int, Bool)>, ControlEvent<(Int, Bool)>) = {
        let subject = PublishSubject<(Int, Bool)>()
        return (subject, ControlEvent<(Int, Bool)>(events: subject.asObserver()))
    }()
    
    init(pagingContentViewController: PagingContentViewController) {
        super.init(parentObject: pagingContentViewController, delegateProxy: RxPagingContentViewControllerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxPagingContentViewControllerDelegateProxy(pagingContentViewController: $0) }
    }

    // MARK:- PagingContentViewControllerDelegate
    
    func contentViewController(viewController: PagingContentViewController, willBeginManualScrollOn index: Int) {
        willBeginManualScrollSubject.onNext(index)
    }

    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        didManualScrollSubject.onNext((index, percent))
    }

    func contentViewController(viewController: PagingContentViewController, didEndManualScrollOn index: Int) {
        didEndManualScrollSubject.onNext(index)
    }
    
    func contentViewController(viewController: PagingContentViewController, willBeginPagingAt index: Int, animated: Bool) {
        willBeginPagingSubject.onNext((index, animated))
    }
    
    func contentViewController(viewController: PagingContentViewController, willFinishPagingAt index: Int, animated: Bool) {
        willFinishPagingSubject.onNext((index, animated))
    }
    
    func contentViewController(viewController: PagingContentViewController, didFinishPagingAt index: Int, animated: Bool) {
        willFinishPagingSubject.onNext((index, animated))
    }
}
