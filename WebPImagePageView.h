//
//  WebPImagePageView.h
//  ImageButter
//
//  Created by Dalton Cherry on 12/7/15.
//

#import <UIKit/UIKit.h>

@class WebPImagePageView;

@protocol WebPImagePageViewDelegate <NSObject>

- (void)didChangeImage:(WebPImagePageView*)view index:(NSInteger)index;

@end


@interface WebPImagePageView : UIView

/**
 The image urls to load
 */
@property(nonatomic)NSArray *urls;

/**
 The delegate to be notifed when the image view does different things (like scrolls)
 */
@property(nonatomic, weak)id<WebPImagePageViewDelegate> delegate;

@end
