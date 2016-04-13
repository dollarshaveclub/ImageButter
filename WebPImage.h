//
//  WebPImage.h
//  ImageButter
//
//  Created by Dalton Cherry on 8/27/15.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

/**
 This is used be WebPImageView for drawing and can be ignored in all most all cases.
 */
@interface WebPFrame : NSObject

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image dispose:(BOOL)dispose blend:(BOOL)blend duration:(NSInteger)duration;

//the frame of this image
@property(nonatomic, readonly)CGRect frame;

//should the we canvas be cleared before drawing this image?
//dispose == YES don't draw anything but this image. NO means to draw the previous frames.
@property(nonatomic, readonly)BOOL dispose;

//should only the last drawing rect have transparent pixels or solid background?
//Blend == YES means it should be transparent and NO means the background color.
@property(nonatomic, readonly)BOOL blend;

//how long should this image frame be display (in milliseconds)?
@property(nonatomic, readonly)NSInteger displayDuration;

//the image object to display for this frame
@property(nonatomic, readonly)UIImage *image;

@end

/**
 Like a UIImage/NSImage but for WebP. Since the biggest weakness of WebP is the slow decoding times, they can be done async to not block the main thread while decoding images (especially animated ones).
 */
@interface WebPImage : NSObject

typedef void (^WebPDecodeFinished)(WebPImage*);
typedef void (^WebPDecodeProgress)(CGFloat);

/**
 Create a new WebPImage object with the data. This is done on the *main* thread and not recommend to be used in almost all cases.
 @param data is the webp data to decode.
 */
- (instancetype)initWithData:(NSData*)data;

/**
 Create a new WebPImage object with the a UIImage. This is hack so you can use a UIImage in a WebPImageView.
 @param image to "convert" to webp.
 */
- (instancetype)initWithImage:(UIImage*)img;

/**
 Create a new WebPImage object with data. The decoding is done on a background thread with this decode.
 @param data is the webp data to decode.
 @param async is triggered once the image is done decoding. nil can be passed.
 */
- (instancetype)initWithData:(NSData*)data async:(WebPDecodeFinished)finished;

/**
 the size of the image. This also accounts for scale on the device so the image isn't grainy.
 */
@property(nonatomic, readonly)CGSize size;

/**
the frames of image. This can be either one WPFrame or multiple if it is animated
 */
@property(nonatomic,readonly)NSArray *frames;

/**
 the background color of the image.
 */
@property(nonatomic, readonly)UIColor *backgroundColor;

/**
Reports if the image is done decoding or not.
 */
@property(nonatomic,readonly)BOOL isDecoded;

/**
get the progress of the decode
 */
@property(nonatomic, strong)WebPDecodeProgress decodeProgress;

/**
this is a property is to be ignored. It is exposed so the WebPImageView can be notified when an async image is ready
 */
@property(nonatomic,strong)WebPDecodeFinished finishedDecode;

/**
 this is a property can be ignored most of the time. It is exposed so the WebPImageView can use it as drawing optimzation for animated gifs
 */
@property(nonatomic, readonly)BOOL hasAlpha;

/**
 Returns true if it is a valid image type.
*/
+ (BOOL)isValidImage:(NSData*)data;

@end
