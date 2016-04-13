//
//  WebPImagePageView.m
//  ImageButter
//
//  Created by Dalton Cherry on 12/7/15.
//

#import "WebPImagePageView.h"
#import "WebPImageView.h"

@interface Recycle : NSObject

@property(nonatomic)WebPImageView *view;
@property(nonatomic)NSInteger index;

@end

@interface WebPImagePageView () <UIScrollViewDelegate>

@property(nonatomic)UIScrollView *scrollView;
@property(nonatomic)NSMutableSet *recycleSet;
@property(nonatomic)NSMutableSet *currentSet;
@property(nonatomic)NSInteger currentIndex;

@end

@implementation WebPImagePageView

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor blackColor];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    self.recycleSet = [[NSMutableSet alloc] init];
    self.currentSet = [[NSMutableSet alloc] init];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat spacing = 10;
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width+spacing, self.bounds.size.height);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*self.urls.count,
                                             self.scrollView.bounds.size.height);
    [self showPage];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/self.scrollView.frame.size.width;
    if(index < 0) {
        index = 0;
    } else if(index > self.urls.count-1) {
        index = self.urls.count-1;
    }
    BOOL didChange = NO;
    if(index != self.currentIndex) {
        didChange = YES;
    }
    self.currentIndex = index;
    if(didChange) {
        [self.delegate didChangeImage:self index:self.currentIndex];
        [self showPage];
    }
}

- (void)showPage {
    if(self.scrollView.bounds.size.width == 0) {
        return;
    }
    //remove old views from screen and add to recycle
    NSInteger indexOffset = 1;
    for(Recycle *item in [self.currentSet allObjects]) {
        if(item.index < self.currentIndex-indexOffset || item.index > self.currentIndex+indexOffset) {
            item.view.pause = YES;
            item.view.image = nil;
            [item.view removeFromSuperview];
            [self.currentSet removeObject:item];
            [self.recycleSet addObject:item];
        }
    }
    //add the views
    for(NSInteger i = self.currentIndex-indexOffset; i <= self.currentIndex+indexOffset; i++) {
        if(i > -1 && i < self.urls.count) {
            Recycle *item = [self dequeueItem];
            item.index = i;
            item.view.url = self.urls[i];
            if(i == self.currentIndex) {
                item.view.pause = NO;
            } else {
                item.view.pause = YES;
            }
            CGFloat x = self.scrollView.frame.size.width*i;
            item.view.frame = CGRectMake(x, 0, self.bounds.size.width, self.bounds.size.height);
            [self.scrollView addSubview:item.view];
            [self.currentSet addObject:item];
        }
    }
}

- (Recycle*)dequeueItem {
    Recycle *item = [self.recycleSet anyObject];
    if(!item) {
        item = [[Recycle alloc] init];
        item.view = [[WebPImageView alloc] init];
    } else {
        [self.recycleSet removeObject:item];
    }
    return item;
}

- (void)setUrls:(NSArray *)urls {
    _urls = urls;
    [self setNeedsLayout];
    self.currentIndex = 0;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self showPage];
}

@end

@implementation Recycle

@end
