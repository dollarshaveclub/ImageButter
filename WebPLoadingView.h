//
//  WebPLoadingView.h
//  ImageButter
//
//  Created by Dalton Cherry on 9/2/15.
//

#import <UIKit/UIKit.h>
#import "WebPImageLoadingProtocol.h"

@interface WebPLoadingView : UIView<WebPImageViewProgressDelegate>

/**
 Set the width of the loading line (stroke).
 */
@property(nonatomic)CGFloat lineWidth;

/**
 Set the color of the loading dialog.
 */
@property(nonatomic)UIColor *lineColor;

/**
 Set if the line has square or rounded edges.
 */
@property(nonatomic)BOOL squareCaps;

/**
 update the progress.
 */
@property(nonatomic)CGFloat progress;

/**
 Change the progress with animation.
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
