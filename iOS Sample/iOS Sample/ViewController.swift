//
//  ViewController.swift
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
    
    let disposeBag = DisposeBag()
    
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
            .disposed(by: disposeBag)
        
        items.asObserver()
            .map { items in items.map({ $0.content }) }
            .bind(to: contentViewController.rx.viewControllers())
            .disposed(by: disposeBag)
        
        menuViewController.rx.itemSelected.asObservable().subscribe(onNext: { [weak self] (page, prev) in
            self?.contentViewController.scroll(to: page, animated: true)
        }).disposed(by: disposeBag)
        
        contentViewController.rx.didManualScroll.asObservable().subscribe(onNext: { [weak self] (index, percent) in
            self?.menuViewController.scroll(index: index, percent: percent, animated: false)
        }).disposed(by: disposeBag)
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


