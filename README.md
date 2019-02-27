# RxPagingKit

[![Platform](https://img.shields.io/cocoapods/p/PagingKit.svg?style=flat)](http://cocoapods.org/pods/PagingKit)
![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/RxPagingKit.svg?style=flat)](http://cocoapods.org/pods/RxPagingKit)
[![Version](https://img.shields.io/cocoapods/v/RxPagingKit.svg?style=flat)](http://cocoapods.org/pods/RxPagingKit)

Reactive Extension for [PagingKit](https://github.com/kazuhiro4949/PagingKit)

# What's this?

# Requirements
+ iOS 8.0+
+ Xcode 10.0+
+ Swift 4.2

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

## Carthage
+ Install Carthage from Homebrew
```
> ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
> brew update
> brew install carthage
```
+ Move your project dir and create Cartfile
```
> touch Cartfile
```
+ add the following line to Cartfile
```
github "kazuhiro4949/RxPagingKit"
```
+ Create framework
```
> carthage update --platform iOS
```

+ In Xcode, move to "Genera > Build Phase > Linked Frameworks and Library"
+ Add RxPagingKit and the dependencies (PagingKit, RxSwift and RxCocoa) to your project
+ Add a new run script and put the following code
```
/usr/local/bin/carthage copy-frameworks
```
+ Click "+" at Input file and Add the framework path
```
$(SRCROOT)/Carthage/Build/iOS/RxPagingKit.framework
$(SRCROOT)/Carthage/Build/iOS/PagingKit.framework
$(SRCROOT)/Carthage/Build/iOS/RxSwift.framework
$(SRCROOT)/Carthage/Build/iOS/RxCocoa.framework
```
+ Write Import statement on your source file
```
import RxPagingKit
import RxSwift
import RxCocoa
import PagingKit
```

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
