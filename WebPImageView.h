//
//  WebPImageView.h
//  WebPObjc
//
//  Created by Dalton Cherry on 8/27/15.
//

#import <UIKit/UIKit.h>
#import "WebPImage.h"
#import "WebPImageLoadingProtocol.h"

@interface WebPImageView : UIView

/**
 Set the image to display.
 */
@property(nonatomic)WebPImage *image;

/**
fetch the image from disk or remotely.
 */
@property(nonatomic)NSURL *url;

/**
 Show a loading view will the image gets fetched.
 */
@property(nonatomic)UIView<WebPImageViewProgressDelegate> *loadingView;

/**
 inset the loading view in the view.
 */
@property(nonatomic)UIEdgeInsets loadingInset;

@end
