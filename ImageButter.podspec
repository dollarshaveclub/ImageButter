Pod::Spec.new do |s|
  s.name         = "ImageButter"
  s.version      = "1.1.0"
  s.summary      = "Image viewer for iOS. Supports static and animated WebP, animated GIF, and standard iOS formats."
  s.homepage     = "https://github.com/dollarshaveclub/ImageButter"
  s.source       = { :git => "https://github.com/dollarshaveclub/ImageButter.git", :tag => "#{s.version}" }
  s.license      = 'MIT'
  s.authors = { 'Dollar Shave Club' => 'http://engineering.dollarshaveclub.com', 'Dalton Cherry' => 'http://daltoniam.com' }
  s.ios.deployment_target = '7.0'
  s.ios.vendored_frameworks = 'WebP.framework'
  s.frameworks   = "ImageIO", "MobileCoreServices", "CoreGraphics"
  s.source_files = '*.{h,m}'
  s.requires_arc = true
end
