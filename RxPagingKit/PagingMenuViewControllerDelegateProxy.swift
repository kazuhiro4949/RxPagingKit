//
//  PagingMenuViewControllerDelegateProxy.swift
//  RxPagingKit
//
//  Created by kahayash on 2019/02/08.
//  Copyright © 2019 Kazuhiro Hayashi. All rights reserved.
//

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
