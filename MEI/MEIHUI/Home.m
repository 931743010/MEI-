//
//  Home.m
//  MEI
//
//  Created by Yosemite on 3/6/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "Home.h"
#import "CategoryItemsList.h"
#import "HeaderFooterManager.h"

@interface Home ()
{
    NSMutableArray *_categoryArr;
    UIScrollView *_scrollView;
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    NSMutableArray *_observerArr;
    BOOL _scrollViewCanResponseToScroll;
    
    CGFloat _headerHeight;
}
@property (nonatomic, assign) NSInteger selectedButtonTag;
@end

@implementation Home

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewWidth = [[self view] bounds].size.width;
    _viewHeight = [[self view] bounds].size.height;
    _headerHeight = (0.220689 - 0.02) * _viewHeight;
    _categoryArr = [[NSMutableArray alloc] initWithCapacity:6];
    _observerArr = [[NSMutableArray alloc] initWithCapacity:7];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [HeaderFooterManager setWindowHeaderViewForViewController:self withHeaderStyle:headerWithNavigationAndShoppingBasket withTitle:nil];
    [[self view] addSubview:[self navigationViewInHeaderBar]];
    [self setSelectedButtonTag:0x9000];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _headerHeight, _viewWidth, _viewHeight - _headerHeight)];
    [[self view] addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(6 * _viewWidth, _viewHeight - _headerHeight)];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setBounces:NO];
    [_scrollView setDelegate:self];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    int categoryId = 12717;
    for (int i = 0; i < 6; i++)
    {
        [_categoryArr addObject:[[[CategoryItemsList alloc] initWithStyle:UITableViewStyleGrouped] autorelease]];
        ((CategoryItemsList *)_categoryArr[i])->_categoryId = categoryId++;
    }
    ((CategoryItemsList *)_categoryArr[0])->_categoryId = -1;
    for (int i = 0; i < 6; i++)
    {
        [[(CategoryItemsList *)_categoryArr[i] tableView] setFrame:CGRectMake(i * _viewWidth, 0, _viewWidth, _viewHeight - _headerHeight)];
        [self addChildViewController:(CategoryItemsList *)_categoryArr[i]];
        [_scrollView addSubview:[(CategoryItemsList *)_categoryArr[i] tableView]];
    }
}

- (void)dealloc
{
    for (int i = 0; i < 7; i++)
    {
        [self removeObserver:_observerArr[i] forKeyPath:@"selectedButtonTag"];
    }
    [_observerArr release];
    [_scrollView release];
    [_categoryArr release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define BUTTONHEIGHT 3.9

- (void)showLeftNavigationView:(UIButton *)button
{
    __block UIViewController *basic = [[self navigationController] parentViewController];
    if ([[basic view] frame].origin.x == 0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [[basic view] setFrame:CGRectMake(2 * _viewWidth / 3, 0, _viewWidth, _viewHeight)];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            [[basic view] setFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
        }];
    }
}

- (UIView *)navigationViewInHeaderBar
{
    UIView *buttonBkgrd = [[UIView alloc] initWithFrame:CGRectMake(0, _headerHeight * (10 - BUTTONHEIGHT) / 10, _viewWidth, _headerHeight * BUTTONHEIGHT / 10)];
    [buttonBkgrd setBackgroundColor:[UIColor blackColor]];
    for (int i = 0; i < 6; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * _viewWidth / 6, 0, _viewWidth / 6, [buttonBkgrd bounds].size.height)];
        [button setTag:0x9000 + i];
        [buttonBkgrd addSubview:button];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:14]];
        [button addTarget:self action:@selector(navigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addObserver:button forKeyPath:@"selectedButtonTag" options:NSKeyValueObservingOptionNew context:nil];
        [_observerArr addObject:button];
        [button release];
        switch (i)
        {
            case 0:
                [button setTitle:@"全部" forState:UIControlStateNormal];
                break;
            case 1:
                [button setTitle:@"女士" forState:UIControlStateNormal];
                break;
            case 2:
                [button setTitle:@"男士" forState:UIControlStateNormal];
                break;
            case 3:
                [button setTitle:@"美妆" forState:UIControlStateNormal];
                break;
            case 4:
                [button setTitle:@"家居" forState:UIControlStateNormal];
                break;
            case 5:
                [button setTitle:@"婴童" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(_viewWidth / 12 - 16.67, 0.8 * [buttonBkgrd bounds].size.height, 33.33, 2)];/*_viewWidth / 6 - 20*/
    [bottom setBackgroundColor:[UIColor whiteColor]];
    [buttonBkgrd addSubview:bottom];
    [self addObserver:bottom forKeyPath:@"selectedButtonTag" options:NSKeyValueObservingOptionNew context:&_viewWidth];
    [_observerArr addObject:bottom];
    [bottom release];
    return buttonBkgrd;
}

- (void)navigationButtonAction:(UIButton *)button
{
    _scrollViewCanResponseToScroll = NO;
    [self setSelectedButtonTag:[button tag]];
    [_scrollView setContentOffset:CGPointMake(([button tag] - 0x9000) * _viewWidth, 0) animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollViewCanResponseToScroll)
    {
        CGFloat offset = [scrollView contentOffset].x;
        NSInteger index = 0.5 + offset / _viewWidth;
        if ([self selectedButtonTag] != index + 0x9000)
        {
            [self setSelectedButtonTag:index + 0x9000];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrollViewCanResponseToScroll = YES;
}

@end

@implementation UIButton (Home_Category)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedButtonTag"])
    {
        NSInteger tag = [[change objectForKey:@"new"] integerValue];
        if (tag == [self tag])
        {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    else if ([keyPath isEqualToString:@"selectedButtonTag_Upcoming"])
    {
        NSInteger buttonTag = [[change objectForKey:@"new"] integerValue];
        if ([self tag] == buttonTag)
        {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
}

@end

@implementation UIView (Home_Category)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedButtonTag"])
    {
        CGFloat num = [[change objectForKey:@"new"] integerValue] - 0x9000 + 0.5;
        [UIView animateWithDuration:0.3 animations:^{
            [self setCenter:CGPointMake(num * *(CGFloat *)context / 6, [self center].y)];
        }];
    }
    else if ([keyPath isEqualToString:@"selectedButtonTag_Upcoming"])
    {
        NSInteger numberOfDays = [self tag];
        CGFloat num = [[change objectForKey:@"new"] integerValue] - 0x9500 + 0.5;
        [UIView animateWithDuration:0.3 animations:^{
            [self setCenter:CGPointMake(num * *(CGFloat *)context / numberOfDays, [self center].y)];
        }];
    }
}

@end
