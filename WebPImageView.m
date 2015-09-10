//
//  WebPImageView.m
//  WebPObjc
//
//  Created by Dalton Cherry on 8/27/15.
//

#import "WebPImageView.h"
#import "WebPImageManager.h"

@interface WebPImageView ()

@property(nonatomic)NSInteger index;
@property(nonatomic)UIImage *prevImg;
@property(nonatomic)CGPoint offsetOrigin;
@property(nonatomic)CGFloat aspectScale;
@property(nonatomic)BOOL animated;
@property(nonatomic)BOOL isClear;
@property(nonatomic)NSInteger urlSessionId;
@property(nonatomic)NSInteger iterationCount; //how times has the animation looped
@property(nonatomic)BOOL moveIndex;

@end

@implementation WebPImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.aspectScale = 1;
        self.loopCount = 0;
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    CGFloat white = 0;
    CGFloat alpha = 0;
    [self.backgroundColor getWhite:&white alpha:&alpha];
    self.isClear = NO;
    if(alpha < 1) {
        self.isClear = YES;
    }
}

- (void)setLoadingView:(UIView<WebPImageViewProgressDelegate> *)loadingView {
    [_loadingView removeFromSuperview];
    _loadingView = loadingView;
    [self addSubview:loadingView];
}

- (void)setImage:(WebPImage *)image {
    _image.finishedDecode = nil; //don't care about the old image anymore
    _image = image;
    if(image) {
        if(!image.isDecoded) {
            self.loadingView.hidden = NO;
            [self.loadingView setProgress:0];
            image.finishedDecode = ^(WebPImage *img){
                [self startDisplay];
            };
            image.decodeProgress = ^(CGFloat pro) {
                [self.loadingView setProgress:pro];
            };
        } else {
            [self startDisplay];
        }
    }
}

- (void)setUrl:(NSURL *)url {
    WebPImageManager *manager = [WebPImageManager sharedManager];
    if(_url) {
        [manager cancelImageForSession:self.urlSessionId url:_url];
    }
    _url = url;
    self.loadingView.hidden = NO;
    [self.loadingView setProgress:0];
    self.urlSessionId = [manager imageForUrl:url progress:^(CGFloat pro) {
        [self.loadingView setProgress:pro];
    } finished:^(WebPImage *img) {
        self.image = img;
    }];
}

- (void)startDisplay {
    self.loadingView.hidden = YES;
    self.animated = NO;
    self.prevImg = nil;
    self.index = 0;
    self.iterationCount = 0;
    [self setNeedsLayout];
    if(self.image.frames.count > 1) {
        self.animated = YES;
        [self doAnimation:self.image.frames[self.index]];
    } else {
        [self setNeedsDisplay];
    }
}

-(void)doAnimation:(WebPFrame*)frame {
    if(!self.animated) {
        return; //stop any running animated
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, frame.displayDuration * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
        if(self.index > 0) {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
            [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
            UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.prevImg = img;
        }
        
        if(self.index >= self.image.frames.count) {
            self.index = 0;
            self.prevImg = nil;
            self.iterationCount++;
            if(self.didFinishAnimation) {
                self.didFinishAnimation(self.iterationCount);
            }
            if(self.iterationCount >= self.loopCount && self.loopCount > 0) {
                return;
            }
        }
        [self setNeedsDisplay];
        self.moveIndex = YES;
        [self doAnimation:self.image.frames[self.index]];
    });
}

-(void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets inset = self.loadingInset;
    self.loadingView.frame = CGRectMake(inset.left, inset.top, self.bounds.size.width-inset.right,
                                        self.bounds.size.height-inset.bottom);
    CGFloat width = self.image.size.width;
    CGFloat height = self.image.size.height;
    if(width > 0 && height > 0) {
        if(width > self.bounds.size.width || height > self.bounds.size.height) {
            if(width > height) {
                height = (height/width)*self.bounds.size.width;
                width = self.bounds.size.width;
                self.aspectScale = self.image.size.width/width;
            } else {
                width = (width/height)*self.bounds.size.height;
                height = self.bounds.size.height;
                self.aspectScale = self.image.size.height/height;
            }
        } else {
            self.aspectScale = 1;
        }
        CGFloat x = (self.bounds.size.width - width)/2;
        CGFloat y = (self.bounds.size.height - height)/2;
        if(x < 0) {
            x = 0;
        }
        if(y < 0) {
            y = 0;
        }
        self.offsetOrigin = CGPointMake(x, y);
    }
}

- (void)drawRect:(CGRect)rect {
    if(self.image.frames.count == 0) {
        return; //nothing to draw so don't even try
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.backgroundColor setFill];
    if(self.prevImg) {
        [self.prevImg drawInRect:self.bounds];
    }
    if(self.index > 0 && self.index < self.image.frames.count) {
        WebPFrame *prevFrame = self.image.frames[self.index-1];
        if(prevFrame.dispose) {
            CGRect imgFrame = CGRectMake(self.offsetOrigin.x + (prevFrame.frame.origin.x/self.aspectScale),
                                         self.offsetOrigin.y + (prevFrame.frame.origin.y/self.aspectScale),
                                         prevFrame.frame.size.width/self.aspectScale, prevFrame.frame.size.height/self.aspectScale);
            if(self.isClear) {
                CGContextClearRect(ctx, imgFrame);
            } else {
                CGContextFillRect(ctx, imgFrame);
            }
        }
    }
    WebPFrame *frame = self.image.frames[self.index];
    CGRect imgFrame = CGRectMake(self.offsetOrigin.x + (frame.frame.origin.x/self.aspectScale),
                                 self.offsetOrigin.y + (frame.frame.origin.y/self.aspectScale),
                                 frame.frame.size.width/self.aspectScale, frame.frame.size.height/self.aspectScale);
    if(!frame.blend) {
        if(self.isClear) {
            CGContextClearRect(ctx, imgFrame);
        } else {
            CGContextFillRect(ctx, imgFrame);
        }
    }
    [frame.image drawInRect:imgFrame];
    if(self.moveIndex) {
        self.index++;
        self.moveIndex = NO;
    }
}

@end
