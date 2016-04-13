//
//  WebPImageLoadingProtocol.h
//  ImageButter
//
//  Created by Dalton Cherry on 9/3/15.
//

#ifndef objc_tester_WebPImageLoadingProtocol_h
#define objc_tester_WebPImageLoadingProtocol_h

@protocol WebPImageViewProgressDelegate <NSObject>

/**
 Have a progress view implement this protocol and it can be used for loading things.
 */
- (void)setProgress:(CGFloat)progress;

@end

#endif
