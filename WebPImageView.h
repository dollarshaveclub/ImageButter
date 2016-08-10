//
//  WebPImageView.h
//  ImageButter
//
//  Created by Dalton Cherry on 8/27/15.
//

#import <UIKit/UIKit.h>
#import "WebPImage.h"
#import "WebPImageLoadingProtocol.h"

@interface WebPImageView : UIView

typedef void (^WebPAnimationFinished)(NSInteger);
typedef void (^WebPImageFinished)(WebPImage*);
typedef void (^WebPImageProgress)(CGFloat);

/**
 Set the image to display.
 */
@property(nonatomic)WebPImage *image;

/**
fetch the image from disk or remotely.
 */
@property(nonatomic)NSURL *url;

/**
 expose the progress and finished blocks for image setting from URL
 */
- (void)setUrl:(NSURL*)url progress:(WebPImageProgress)progress finished:(WebPImageFinished)finished;

/**
 Show a loading view will the image gets fetched.
 */
@property(nonatomic)UIView<WebPImageViewProgressDelegate> *loadingView;

/**
 inset the loading view in the view.
 */
@property(nonatomic)UIEdgeInsets loadingInset;

/**
 how many times should animation images repeat? Default is 0 which means keep looping forever.
 */
@property(nonatomic)NSInteger loopCount;

/**
 Set to true to pause the animation.
 */
@property(nonatomic)BOOL pause;

/**
 notifies when an animation has finished a loop.
 */
@property(nonatomic, strong)WebPAnimationFinished didFinishAnimation;

/**
 returns the current aspect scaling that is being applied to the image (1 means none)
 */
@property(nonatomic, readonly)CGFloat aspect;

@end
