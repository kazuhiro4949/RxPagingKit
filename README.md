# RxPagingKit

[![Platform](https://img.shields.io/cocoapods/p/PagingKit.svg?style=flat)](http://cocoapods.org/pods/PagingKit)
![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Reactive Extension for [PagingKit](https://github.com/kazuhiro4949/PagingKit)

# What's this?

# Requirements
+ iOS 8.0+
+ Xcode 10.0+
+ Swift 4.2

# Installation

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

