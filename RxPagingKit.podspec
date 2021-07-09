#
# Be sure to run `pod lib lint StringStylizer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RxPagingKit"
  s.version          = "1.0.0"
  s.summary          = "Reactive Extension for PagingKit"

  s.description      = <<-DESC
You can implement the binding with Reactive Programming instead of Delegate pattern.
                         DESC

  s.homepage         = "https://github.com/kazuhiro4949/RxPagingKit"
  s.license          = 'MIT'
  s.author           = { "Kazuhiro Hayashi" => "k.hayashi.info@gmail.com" }
  s.source           = { :git => "https://github.com/kazuhiro4949/RxPagingKit.git", :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.1'

  s.source_files = 'RxPagingKit/Classes/**/*'
  
  s.dependency 'RxSwift', '~> 6'
  s.dependency 'RxCocoa', '~> 6'
  s.dependency 'PagingKit', '~> 1.18'
end

