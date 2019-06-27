//
//  NavigationBarViewController.swift
//  iOS Sample
//
//  Created by Meng Li on 2019/6/27.
//  Copyright © 2019 Kazuhiro Hayashi. All rights reserved.
//

import UIKit
import PagingKit
import RxPagingKit
import RxSwift

class NavigationBarViewController: UIViewController {
    
    lazy var menuView: PagingMenuView = {
        let menuView = PagingMenuView()
        menuView.cellAlignment = .center
        menuView.register(type: TitleLabelMenuViewCell.self, with: "identifier")
        menuView.registerFocusView(view: UnderlineFocusView())
        menuView.rx.itemSelected.subscribe(onNext: { [unowned self] in
            self.menuView.scroll(index: $0)
            self.contentViewController.scroll(to: $0, animated: true)
        }).disposed(by: disposeBag)
        return menuView
    }()
    
    private lazy var contentViewController: PagingContentViewController = {
        let controller = PagingContentViewController()
        controller.rx.didManualScroll.subscribe(onNext: { index, percent in
            self.menuView.scroll(index: index, percent: percent)
        }).disposed(by: disposeBag)
        return controller
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = menuView
        
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
        
        Observable.just(["1", "2", "3"].map {
             ($0, 50)
        }).bind(to: menuView.rx.items(
            cellIdentifier: "identifier",
            cellType: TitleLabelMenuViewCell.self
        )) { _, model, cell in
            cell.titleLabel.text = model
        }.disposed(by: disposeBag)
        
        Observable.just([UIColor.red, UIColor.yellow, UIColor.blue].map {
            let controller = UIViewController()
            controller.view.backgroundColor = $0
            return controller
        }).bind(to: contentViewController.rx.viewControllers()).disposed(by: disposeBag)
    }
    
}
