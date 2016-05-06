# ImageButter
 Image viewer for iOS that supports WebP. What is WebP? Find out more [here](https://developers.google.com/speed/webp/).
 
 You can find more about why we created this [here](http://engineering.dollarshaveclub.com/shaving-our-image-size/).

## Features

- Animated WebP images support
- Remote fetching and caching
- Avoids duplicated requests
- Async decoding
- Loading/progress view
- Animated GIFs
- PNG/JPG/other standard iOS formats

## Example

```objc
WebPImageView *imgView = [[WebPImageView alloc] initWithFrame:CGRectMake(0, 30, 300, 300)];
[self.view addSubview:imgView];
imgView.url = [NSURL URLWithString:@"https://yourUrl/imageName@3x.webp"];

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
That will fetch the image, cache it, and decoding it all asynchronously. It will show a progress view showing the total download and display time. The can see the value of it being a WebP image here:

![graph](https://raw.githubusercontent.com/dollarshaveclub/ImageButter/assets/image-size-graph.jpg)

## Requirements ##

ImageButter requires at least iOS 7 or above. 
Dependencies are ImageIO, MobileCoreServices, CoreGraphics, and CommonCrypto.

## Installation

### CocoaPods

Check out [Get Started](https://guides.cocoapods.org/using/getting-started.html) tab on [cocoapods.org](http://cocoapods.org/).

Install CocoaPods if not already available:

	$ [sudo] gem install cocoapods
	$ pod setup

To use ImageButter in your project add the following 'Podfile' to your project

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '9.0'
	pod 'ImageButter'

Then run:

    pod install

## Tests

One of our TODOs. We would mighty appreciate any PRs in this department.
	
## License

ImageButter is Copyright (c)2016, Dollar Shave Club, INC. It is free software, and may be redistributed under the terms specified in the LICENSE file (MIT License).

## Contact

### Dollar Shave Club

* https://www.dollarshaveclub.com
* https://github.com/dollarshaveclub
* http://engineering.dollarshaveclub.com


### Dalton Cherry
* https://github.com/daltoniam
* http://twitter.com/daltoniam
* http://daltoniam.com
