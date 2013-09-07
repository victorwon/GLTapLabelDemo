#
# Be sure to run `pod spec lint GLTapLabelDemo.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "GLTapLabelDemo"
  s.version      = "0.0.1"
  s.summary      = "UILabel with tap detection on words."
  s.description  = "A twitter style UILabel that is tappable once you set the enableUserInteractive to YES."
  s.homepage     = "https://github.com/victorwon/GLTapLabelDemo"
  s.license      = 'MIT'
  s.authors      = { "victorwon" => "email@address.com", "German Laullon" => "laullon@gmail.com" }
  s.source       = { :git => "https://github.com/victorwon/GLTapLabelDemo.git", 
		     :tag => s.version.to_s }
  s.platform     = :ios, '6.0'
  s.source_files = 'GLTapLabel', 'GLTapLabel/**/*.{h,m}'

  s.framework  = 'CoreText'

  s.requires_arc = true

end
