//
//  HPLoadingExtension.h
//  LoadingExample
//
//  Created by Huy Pham on 8/8/14.
//  Copyright (c) 2014 CoreDump. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPLoadingExtension : NSObject

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, readonly, getter=isLoadingMore) BOOL loadingMore;

@property (nonatomic, strong) UIColor *circleColor;

@property (nonatomic) CGFloat progressDistanceTop;
@property (nonatomic) CGFloat progressDistanceBottom;

- (void)addRefreshHandler:(void (^)(void))refreshHandler;
- (void)addLoadMoreHandler:(void (^)(void))loadMoreHandler;

- (void)stopRefresh;
- (void)stopLoadMore;

@end
