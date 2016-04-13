//
//  WebPLoadingView.m
//  ImageButter
//
//  Created by Dalton Cherry on 9/2/15.
//

#import "WebPLoadingView.h"

@interface WebPLoadingView ()

@property(nonatomic)CAShapeLayer *shapeLayer;

@end

@implementation WebPLoadingView

#define pi 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.shapeLayer = (CAShapeLayer*)self.layer;
        self.squareCaps = NO;
        self.lineColor = [UIColor whiteColor];
        self.lineWidth = 4;
        self.progress = 0;
        self.backgroundColor = [UIColor clearColor];
        self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
        self.shapeLayer.strokeEnd = 0;
        self.transform = CGAffineTransformRotate(self.transform, DEGREES_TO_RADIANS(270));
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shapeLayer.path = [self buildPath:self.bounds].CGPath;
}

- (UIBezierPath*)buildPath:(CGRect)rect {
    CGFloat pad = self.lineWidth/2;
    CGRect frame = rect;
    frame.size.width = floor(rect.size.width-(pad*2));
    frame.size.height = floor(rect.size.height-(pad*2));
    frame.origin.x = pad;
    frame.origin.y = pad;
    return  [UIBezierPath bezierPathWithOvalInRect:frame];
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)setSquareCaps:(BOOL)squareCaps {
    _squareCaps = squareCaps;
    if (squareCaps) {
        self.shapeLayer.lineCap = kCALineCapSquare;
    } else {
        self.shapeLayer.lineCap = kCALineCapRound;
    }
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.shapeLayer.strokeColor = lineColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.shapeLayer.lineWidth = lineWidth;
}

- (void)setProgress:(CGFloat)progress {
    CGFloat pro = progress;
    if (pro < 0) {
        pro = 0;
    } else if (pro > 1) {
        pro = 1;
    }
    _progress = pro;
    self.shapeLayer.strokeEnd = pro;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    CGFloat pro = progress;
    if (pro < 0) {
        pro = 0;
    } else if (pro > 1) {
        pro = 1;
    }
    [self.shapeLayer removeAnimationForKey:@"strokeEnd"];
    [CATransaction begin];
    CABasicAnimation* animate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animate.fromValue = @(self.shapeLayer.strokeEnd);
    animate.toValue = @(pro);
    animate.duration = 0.5;
    animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.shapeLayer addAnimation:animate forKey:@"strokeEnd"];
    self.progress = pro;
    [CATransaction commit];
}

@end
