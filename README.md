# RxPagingKit

[![Platform](https://img.shields.io/cocoapods/p/PagingKit.svg?style=flat)](http://cocoapods.org/pods/PagingKit)
![Swift 5.1](https://img.shields.io/badge/Swift-5.1-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/RxPagingKit.svg?style=flat)](http://cocoapods.org/pods/RxPagingKit)
[![Version](https://img.shields.io/cocoapods/v/RxPagingKit.svg?style=flat)](http://cocoapods.org/pods/RxPagingKit)

Reactive Extension for [PagingKit](https://github.com/kazuhiro4949/PagingKit)

# What's this?

# Requirements
+ iOS 9.0+
+ Xcode 10.0+
+ Swift 5.1+

# Installation

### CocoaPods
+ Install CocoaPods
```
> gem install cocoapods
> pod setup
```
+ Create Podfile
```
> pod init
```
+ Edit Podfile
```ruby
target 'YourProject' do
  use_frameworks!

  pod "RxPagingKit" # add

  target 'YourProject' do
    inherit! :search_paths
  end

  target 'YourProject' do
    inherit! :search_paths
  end

end
```

+ Install

```
> pod install
```
open .xcworkspace

## Swift Packgae Manager

Add RxPagingKit to your project via Xcode.

# Example
You can implement the binding with Reactive Programming instead of Delegate pattern.

```swift
    let items = PublishSubject<[(menu: String, width: CGFloat, content: UIViewController)]>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuViewController?.register(type: TitleLabelMenuViewCell.self, forCellWithReuseIdentifier: "identifier")
        menuViewController?.registerFocusView(view: UnderlineFocusView())
        
        // PagingMenuViewControllerDataSource
        items.asObserver()
            .map { items in items.map({ ($0.menu, $0.width) }) }
            .bind(to: menuViewController.rx.items(
                cellIdentifier: "identifier",
                cellType: TitleLabelMenuViewCell.self)
            ) { _, model, cell in
                cell.titleLabel.text = model
            }
            .disposed(by: disposeBag)
        
        // PagingContentViewControllerDataSource
        items.asObserver()
            .map { items in items.map({ $0.content }) }
            .bind(to: contentViewController.rx.viewControllers())
            .disposed(by: disposeBag)
        
        // PagingMenuViewControllerDelegate
        menuViewController.rx.itemSelected.asObservable().subscribe(onNext: { [weak self] (page, prev) in
            self?.contentViewController.scroll(to: page, animated: true)
        }).disposed(by: disposeBag)
        
        // PagingContentViewControllerDelegate
        contentViewController.rx.didManualScroll.asObservable().subscribe(onNext: { [weak self] (index, percent) in
            self?.menuViewController.scroll(index: index, percent: percent, animated: false)
        }).disposed(by: disposeBag)
    }
```
