//
//  ViewController.m
//  LoadingExample
//
//  Created by Huy Pham on 8/8/14.
//  Copyright (c) 2014 CoreDump. All rights reserved.
//

#import "ViewController.h"

#import "HPLoadingExtension.h"

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) HPLoadingExtension *loadingExtension;

@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [tableView setDataSource:self];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:view];
    
    _loadingExtension = [[HPLoadingExtension alloc] initWithScrollView:tableView];
    
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
    
    [self.view addSubview:tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

@end
