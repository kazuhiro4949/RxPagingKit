//
//  PagingContentViewControllerDelegateProxy.swift
//  RxPagingKit
//
//  Created by kahayash on 2019/02/08.
//  Copyright © 2019 Kazuhiro Hayashi. All rights reserved.
//

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
