HPLoadingExtension *loadingExtension = [[HPLoadingExtension alloc] initWithScrollView:tableView];

    __weak ViewController *weakSelf = self;
    [_loadingExtension addLoadMoreHandler:^{
        [UIView animateWithDuration:5.0 animations:^{
            // Fake loading.
            [view setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
        } completion:^(BOOL finished) {
            [view setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            [weakSelf.loadingExtension stopLoadMore];
        }];
    }];

    [_loadingExtension addRefreshHandler:^{
        [UIView animateWithDuration:5.0f animations:^{
            // Fake loading.
            [view setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
        } completion:^(BOOL finished) {
            [view setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            [weakSelf.loadingExtension stopRefresh];
        }];
    }];

