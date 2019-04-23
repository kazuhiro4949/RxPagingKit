#
# Be sure to run `pod lib lint StringStylizer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RxPagingKit"
  s.version          = "0.4.0"
  s.summary          = "Reactive Extension for PagingKit"

  s.description      = <<-DESC
You can implement the binding with Reactive Programming instead of Delegate pattern.
                         DESC

  s.homepage         = "https://github.com/kazuhiro4949/RxPagingKit"
  s.license          = 'MIT'
  s.author           = { "Kazuhiro Hayashi" => "k.hayashi.info@gmail.com" }
  s.source           = { :git => "https://github.com/kazuhiro4949/RxPagingKit.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = "RxPagingKit/*.{swift,h}"
  s.dependency 'RxSwift', '~> 4.5'
  s.dependency 'RxCocoa', '~> 4.5'
  s.dependency 'PagingKit', '~> 1.10.0'
end
