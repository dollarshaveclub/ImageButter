Pod::Spec.new do |s|
  s.name         = "ImageButter"
  s.version      = "1.0.0"
  s.summary      = "Image viewer for iOS. Supports static and animated WebP, animated GIF, and standard iOS formats. Remote loading and caching with progress view."
  s.homepage     = "https://github.com/dollarshaveclub/ImageButter"
  s.source       = { :git => "https://github.com/dollarshaveclub/ImageButter.git", :tag => "#{s.version}" }
  s.ios.deployment_target = '7.0'
  s.ios.vendored_frameworks = 'WebP.framework'
  s.frameworks   = "ImageIO", "MobileCoreServices", "CoreGraphics"
  s.source_files = '*.{h,m}'
  s.requires_arc = true
end
