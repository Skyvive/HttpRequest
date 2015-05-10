#
#  Be sure to run `pod spec lint JsonObject.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name = "HttpRequest"
  s.version = "0.8.0"
  s.summary = "Http Request Made Easy"
  s.homepage = "https://github.com/Skyvive/HttpRequest"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Brad Hilton" => "brad.hilton.nw@gmail.com" }
  s.ios.deployment_target = "8.3"
  s.osx.deployment_target = "10.9"
  s.source = { :git => "https://github.com/Skyvive/HttpRequest.git", :tag => "0.8.0" }
  s.source_files  = "HttpRequest", "HttpRequest/**/*.{swift,h,m}"
  s.requires_arc = true
  s.dependency 'JsonSerializer', '~> 0.8.1'

end
