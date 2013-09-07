Pod::Spec.new do |s|
  s.name     = 'GLTapLabel'
  s.version  = '1.0.1'
  s.license  = 'MIT'
  s.summary  = 'Attributed UILabel supports tapping on twitter style hot words.'
  s.homepage = 'https://github.com/victorwon/GLTapLabelDemo'
  s.author   = { 'German Laullon' => 'laullon@gmail.com' }
  s.source   = { :git => 'https://github.com/victorwon/GLTapLabelDemo.git' }
  s.platform = :ios
  s.source_files = 'GLTapLabel'
  s.requires_arc = true
  s.framework = 'CoreText'
end
