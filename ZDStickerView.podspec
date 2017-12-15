Pod::Spec.new do |s|
  s.name			= 'ZDStickerView'
  s.version			= '0.2.0'
  s.summary 		= 'ZDStickerView is ObjC module for iOS and offers complete configurability, including movement, resizing, rotation and more, with one finger.'
  s.homepage 		= 'https://www.cocoacontrols.com/controls/zdstickerview'
  s.screenshots 	= 'https://github.com/zedoul/ZDStickerView/blob/develop/SCREENSHOT.png?raw=true'
  s.license 		= { :type => 'MIT', :file => 'LICENSE' }
  s.author 			= { 'zedoul' => 'shyeon.kim@scipi.net' }
  s.platform 		= :ios, '7.0'
  s.source 			= { :git => 'https://github.com/zedoul/ZDStickerView.git', :tag => "v#{s.version}" }
  s.source_files	= 'ZDStickerView/*.{h,m}'
  s.resources 		= 'ZDStickerView/ZDStickerView.bundle'
  s.frameworks 		= 'QuartzCore'
  s.requires_arc 	= true
end
