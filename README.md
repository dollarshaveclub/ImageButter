# WebPObjc
WebP image viewer for iOS. What is WebP? Find out more [here](https://developers.google.com/speed/webp/). TLDR; Small images and they download fast. This is a big win on mobile to preserve bandwidth and make images load fast even on slower connections.

## Features

- Animated WebP images support (think gifs!)
- Remote fetching and caching
- Avoids duplicated requests
- Async decoding
- Loading/progress view
- Animated Gifs
- PNGs/JPG/standard formats

## Example

```objc
WebPImageView *imgView = [[WebPImageView alloc] initWithFrame:CGRectMake(0, 30, 300, 300)];
[self.view addSubview:imgView];
imgView.url = [NSURL URLWithString:@"http://res.cloudinary.com/demo/image/upload/fl_awebp/cell_animation.webp"];

//load from disk
//NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"randomImage.webp"];
//imgView.url = [NSURL fileURLWithPath:path];

//add the loading View.
WebPLoadingView *loadingView = [[WebPLoadingView alloc] init];
loadingView.lineColor = [UIColor orangeColor];
loadingView.lineWidth = 8;
//add the loading view to the imageView.
imgView.loadingView = loadingView;
//if you want to add some inset on the image.
CGFloat pad = 20;
imgView.loadingInset = UIEdgeInsetsMake(pad, pad, pad*2, pad*2);
```
That will fetch the image, cache it, and decoding it all asynchronously. It will show a progress view showing the total download and display time. The outcome looks something like so:

![](http://res.cloudinary.com/demo/image/upload/fl_awebp/cell_animation.webp)

You can't see the image above? Sadness. You should open this in the Chrome browser, as it support WebP images.


## Requirements ##

WebPObjc requires at least iOS 7 or above. 
Dependencies are ImageIO, MobileCoreServices, CoreGraphics, and CommonCrypto.

## Installation

### Cocoapods

Check out [Get Started](https://guides.cocoapods.org/using/getting-started.html) tab on [cocoapods.org](http://cocoapods.org/).

Install CocoaPods if not already available:

	$ [sudo] gem install cocoapods
	$ pod setup

To use WebPObjc in your project add the following 'Podfile' to your project

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '8.0'
	pod 'WebPObjc'

Then run:

    pod install