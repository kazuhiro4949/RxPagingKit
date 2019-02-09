//
//  ViewController.swift
//  iOS Sample
//
//  Created by kahayash on 2019/02/09.
//  Copyright © 2019 Kazuhiro Hayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PagingKit
import RxPagingKit

class ViewController: UIViewController {
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    
    let items = PublishSubject<[SampleDataSourceFactory.Item]>()
    
    lazy var firstLoad: (() -> Void)? = { [weak self, menuViewController, contentViewController] in
        let dataSource = SampleDataSourceFactory.make()
        self?.items.on(.next(dataSource))
        self?.firstLoad = nil
    }
    
    let disposeBug = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuViewController?.register(type: TitleLabelMenuViewCell.self, forCellWithReuseIdentifier: "identifier")
        menuViewController?.registerFocusView(view: UnderlineFocusView())
        
        
        items.asObserver()
            .map { items in items.map({ ($0.menu, $0.width) }) }
            .bind(to: menuViewController.rx.items(
                cellIdentifier: "identifier",
                cellType: TitleLabelMenuViewCell.self)
            ) { _, model, cell in
                cell.titleLabel.text = model
            }
            .disposed(by: disposeBug)
        
        items.asObserver()
            .map { items in items.map({ $0.content }) }
            .bind(to: contentViewController.rx.viewControllers())
            .disposed(by: disposeBug)
        
        menuViewController.rx.itemSelected.asObservable().subscribe(onNext: { [weak self] (page, prev) in
            self?.contentViewController.scroll(to: page, animated: true)
        }).disposed(by: disposeBug)
        
        contentViewController.rx.didManualScroll.asObservable().subscribe(onNext: { [weak self] (index, percent) in
            self?.menuViewController.scroll(index: index, percent: percent, animated: false)
        }).disposed(by: disposeBug)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        firstLoad?()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
        } else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
        }
    }
}

struct SampleDataSourceFactory {
    typealias Item = (menu: String, width: CGFloat, content: UIViewController)
    
    static func make() -> [Item] {
        return ["Martinez", "Alfred", "Louis", "Justin"].enumerated().map { (index, title) in
            let width = UIScreen.main.bounds.width / 4
            let vc = UIViewController()
            vc.view.backgroundColor = index % 2 == 0 ? .red : .blue
            return (menu: title, width: width, content: vc)
        }
    }
}


