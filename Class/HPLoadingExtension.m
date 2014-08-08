//
//  HPLoadingExtension.m
//  LoadingExample
//
//  Created by Huy Pham on 8/8/14.
//  Copyright (c) 2014 CoreDump. All rights reserved.
//

#define PADDING_TOP 45.0f
#define COLOR_DEFAULT [UIColor redColor]

#import "HPLoadingExtension.h"

@interface HPLoadingExtension ()

@property (nonatomic, copy) void (^loadMoreHandler)(void);
@property (nonatomic, copy) void (^refreshHandler)(void);
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation HPLoadingExtension
{
    UIView *_refreshControl;
    UIView *_loadMoreControl;
    
    UIView *_refreshCircle;
    UIView *_loadMoreCircle;
    
    CAShapeLayer *_progressLayer;
    
    BOOL autoScroll;
    
    BOOL refreshAnimating;
    BOOL loadMoreAnimating;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (!(self = [super init])) {
        return nil;
    }
    _scrollView = scrollView;
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    // Init fresh control.
    _refreshControl = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.bounds)/2.0f-20.0f, -_scrollView.contentInset.top-PADDING_TOP, 40.0f, 40.0f)];
    [_refreshControl setBackgroundColor:[UIColor clearColor]];
    [_scrollView addSubview:_refreshControl];
    
    _refreshCircle = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_refreshControl.bounds)/2.0f-12.f, CGRectGetHeight(_refreshControl.bounds)/2.0f-12.0f, 24, 24)];
    [_refreshCircle.layer setCornerRadius:CGRectGetWidth(_refreshCircle.bounds)/2.0f];
    [_refreshCircle setClipsToBounds:YES];
    [_refreshCircle setBackgroundColor:COLOR_DEFAULT];
    [_refreshCircle setHidden:YES];
    [_refreshControl addSubview:_refreshCircle];
    
    _progressLayer = [[CAShapeLayer alloc] init];
    [_progressLayer setStrokeColor:COLOR_DEFAULT.CGColor];
    [_progressLayer setStrokeEnd:0.0f];
    _progressLayer.lineWidth = 3.0f;
    [_progressLayer setFillColor:[UIColor clearColor].CGColor];
    [_progressLayer setFrame:_refreshCircle.frame];
    [_refreshControl.layer addSublayer:_progressLayer];
    
    // Init load more control.
    _loadMoreControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40.0f, 40.0f)];
    [_loadMoreControl setBackgroundColor:[UIColor clearColor]];
    [_loadMoreControl setHidden:YES];
    [_scrollView addSubview:_loadMoreControl];
    
    _loadMoreCircle = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_loadMoreControl.bounds)/2.0f-12.f, CGRectGetHeight(_loadMoreControl.bounds)/2.0f-12.0f, 24, 24)];
    [_loadMoreCircle.layer setCornerRadius:CGRectGetWidth(_loadMoreCircle.bounds)/2.0f];
    [_loadMoreCircle setClipsToBounds:YES];
    [_loadMoreCircle setBackgroundColor:COLOR_DEFAULT];
    [_loadMoreControl addSubview:_loadMoreCircle];
    
    _progressDistanceTop = 90.0f;
    _progressDistanceBottom = 15.0f;
    
    _refreshing = NO;
    _loadingMore = NO;
    
    refreshAnimating = NO;
    loadMoreAnimating = NO;
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)zoomInRefreshing
{
    [UIView animateWithDuration:0.8 animations:^{
        [_refreshCircle setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:^(BOOL finished) {
        if (!_refreshing) {
            return;
        }
        [self zoomOutRefreshing];
        [self createCircleForView:_refreshControl];
    }];
}

- (void)zoomOutRefreshing
{
    [UIView animateWithDuration:0.8 animations:^{
        [_refreshCircle setTransform:CGAffineTransformMakeScale(0.5, 0.5)];
    } completion:^(BOOL finished) {
        if (!_refreshing) {
            return;
        }
        [self zoomInRefreshing];
    }];
}

- (void)zoomInLoadMore
{
    [UIView animateWithDuration:0.8 animations:^{
        [_loadMoreCircle setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:^(BOOL finished) {
        if (!_loadingMore) {
            return;
        }
        [self zoomOutLoadMore];
        [self createCircleForView:_loadMoreControl];
    }];
}

- (void)zoomOutLoadMore
{
    [UIView animateWithDuration:0.8 animations:^{
        [_loadMoreCircle setTransform:CGAffineTransformMakeScale(0.5, 0.5)];
    } completion:^(BOOL finished) {
        if (!_loadingMore) {
            return;
        }
        [self zoomInLoadMore];
    }];
}

- (void)createCircleForView:(UIView *)view
{
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(view.bounds)/2.0f-20.f, CGRectGetHeight(view.bounds)/2.0f-20.0f, 40, 40)];
    [circle.layer setCornerRadius:CGRectGetWidth(circle.bounds)/2.0f];
    [circle setClipsToBounds:YES];
    [circle setBackgroundColor:[UIColor clearColor]];
    [circle.layer setBorderWidth:3.0f];
    [circle.layer setBorderColor:COLOR_DEFAULT.CGColor];
    [circle setTransform:CGAffineTransformMakeScale(0.6, 0.6)];
    [view addSubview:circle];
    [UIView animateWithDuration:3.0 animations:^{
        [circle setAlpha:0.0];
        [circle.layer setBorderWidth:1.0f];
        [circle setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:^(BOOL finished) {
        [circle removeFromSuperview];
    }];
}

- (void)startRefreshAnimating
{
    if (self.refreshing || refreshAnimating) {
        return;
    }
    refreshAnimating = YES;
    [_refreshCircle setHidden:NO];
    [_progressLayer setHidden:YES];
    [_progressLayer setStrokeEnd:0.0f];
    [self updatePath];
    _refreshing = YES;
    [self zoomInRefreshing];
    if (self.refreshHandler) {
        self.refreshHandler();
    }
}

- (void)startLoadingMore
{
    if (self.loadingMore || loadMoreAnimating) {
        return;
    }
    loadMoreAnimating = YES;
    _loadingMore = YES;
    [_loadMoreControl setFrame:CGRectMake(CGRectGetWidth(_scrollView.bounds)/2.0f-20.0f, _scrollView.contentSize.height, 40.0f, 40.0f)];
    [_loadMoreControl setHidden:NO];
    [self zoomInLoadMore];
    if (self.loadMoreHandler) {
        self.loadMoreHandler();
    }
}

- (void)stopRefresh
{
    _refreshing = NO;
    [_refreshCircle setHidden:YES];
    [self performSelector:@selector(resetRefreshState) withObject:nil afterDelay:1.0f];
}

- (void)resetRefreshState
{
    refreshAnimating = NO;
    [_refreshCircle setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [_progressLayer setHidden:NO];
    autoScroll = NO;
    if (!_scrollView.isTracking && _scrollView.contentOffset.y < -_scrollView.contentInset.top) {
        [_scrollView setContentOffset:CGPointMake(0, -_scrollView.contentInset.top) animated:YES];
    }
}

- (void)stopLoadMore
{
    _loadingMore = NO;
    [_loadMoreControl setHidden:YES];
    [self performSelector:@selector(resetLoadMoreState) withObject:nil afterDelay:1.0f];
}

- (void)resetLoadMoreState
{
    loadMoreAnimating = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat contentOffset = _scrollView.contentOffset.y+_scrollView.contentInset.top;
    if (contentOffset<0) {
        
        if (contentOffset<-PADDING_TOP-5.0f) {
            CGRect frame = _refreshControl.frame;
            frame.origin.y = -_scrollView.contentInset.top + contentOffset+5.0f;
            [_refreshControl setFrame:frame];
        }
        
        if (!refreshAnimating && _scrollView.isTracking) {
            [_progressLayer setStrokeEnd:fabs(contentOffset/_progressDistanceTop)-0.15];
            [self updatePath];
        }
        if (contentOffset<-_progressDistanceTop && !self.refreshing && !_scrollView.isTracking) {
            [self startRefreshAnimating];
            autoScroll = YES;
        }
        if (contentOffset<-_progressDistanceTop && self.refreshing && _scrollView.isTracking) {
            autoScroll = YES;
        }
        if (_scrollView.isDecelerating && autoScroll && self.refreshing) {
            autoScroll = NO;
            [_scrollView setContentOffset:CGPointMake(0, -_scrollView.contentInset.top-50.0f) animated:YES];
        }
    } else {
        if (_scrollView.contentSize.height < 50) return;
        CGFloat offset = _scrollView.contentOffset.y + _scrollView.bounds.size.height - _scrollView.contentInset.bottom;
        if(offset > _scrollView.contentSize.height+_progressDistanceBottom && !self.loadingMore && !_scrollView.isTracking) {
            [self startLoadingMore];
        }
        
    }
}

- (void)updatePath
{
    CGPoint center = CGPointMake(CGRectGetMidX(_refreshCircle.bounds), CGRectGetMidY(_refreshCircle.bounds));
    _progressLayer.path = [UIBezierPath bezierPathWithArcCenter:center radius:_refreshCircle.bounds.size.width/2-2 startAngle:-M_PI_2 endAngle:-M_PI_2+2*M_PI clockwise:YES].CGPath;
}

- (void)addLoadMoreHandler:(void (^)(void))loadMoreHandler
{
    _loadMoreHandler = loadMoreHandler;
}

- (void)addRefreshHandler:(void (^)(void))refreshHandler
{
    _refreshHandler = refreshHandler;
}

- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [_refreshCircle setBackgroundColor:circleColor];
    [_loadMoreCircle setBackgroundColor:circleColor];
    [_progressLayer setStrokeColor:circleColor.CGColor];
}

@end
