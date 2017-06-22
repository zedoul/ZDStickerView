#
# Be sure to run `pod lib lint NXDrawKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZDStickerView'
  s.version          = '0.1.18'
  s.summary          = 'ZDStickerView is ObjC module for iOS and offers complete configurability, including movement, resizing, rotation and more, with one finger.'
  s.description      = 'ZDStickerView is ObjC module for iOS and offers complete configurability, including movement, resizing, rotation and more, with one finger.'

  s.homepage         = 'https://bitbucket.org/actions-micro/amzdstickerview'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nicejinux' => 'nicejinux@gmail.com' }
  s.source           = { :git => 'git@bitbucket.org:actions-micro/amzdstickerview.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nicejinux'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZDStickerView/*.{h,m,swift}'
  
  s.resource_bundles = {
    'ZDStickerView' => ['ZDStickerView/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'SnapKit', '= 0.22.0'
  s.frameworks = 'QuartzCore'
end
