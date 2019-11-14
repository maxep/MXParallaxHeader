#
# Be sure to run `pod lib lint MXParallaxHeader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MXParallaxHeader"
  s.version          = "1.1.0"
  s.summary          = "Simple parallax header for UIScrollView."
  s.description      = <<-DESC
  							MXParallaxHeader is a simple header class for UIScrolView.

							In addition, MXScrollView is a UIScrollView subclass with the ability to hook the vertical scroll from its subviews, this can be used to add a parallax header to complex view hierachy.
							Moreover, MXScrollViewController allows you to add a MXParallaxHeader to any kind of UIViewController.
                       DESC

  s.homepage         = "https://github.com/maxep/MXParallaxHeader"
  s.license          = 'MIT'
  s.author           = { "Maxime Epain" => "maxime.epain@gmail.com" }
  s.source           = { :git => "https://github.com/maxep/MXParallaxHeader.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MaximeEpain'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Sources/*.{m,h}'

end
