//
//  Home.m
//  MEI
//
//  Created by Yosemite on 3/6/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "Home.h"
#import "CategoryItemsList.h"
#define HEADERBARHEIGHT 90

@interface Home ()
{
    NSMutableArray *_categoryArr;
    UIScrollView *_scrollView;
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    NSMutableArray *_observerArr;
    NSInteger _scrollViewOldIndex;
    BOOL _scrollViewCanResponseToScroll;
}
@property (nonatomic, retain) NSNumber *selectedButtonTag;
@end

@implementation Home

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewWidth = [[self view] bounds].size.width;
    _viewHeight = [[self view] bounds].size.height;
    _categoryArr = [[NSMutableArray alloc] initWithCapacity:6];
    _observerArr = [[NSMutableArray alloc] initWithCapacity:7];
    [[self view] addSubview:[self navigationViewInHeaderBar]];
    [self setSelectedButtonTag:[NSNumber numberWithInteger:0x9000]];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HEADERBARHEIGHT, _viewWidth, _viewHeight - HEADERBARHEIGHT)];
    [[self view] addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(6 * _viewWidth, _viewHeight - HEADERBARHEIGHT)];
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
        [[(CategoryItemsList *)_categoryArr[i] tableView] setFrame:CGRectMake(i * _viewWidth, 0, _viewWidth, _viewHeight - HEADERBARHEIGHT)];
        [self addChildViewController:(CategoryItemsList *)_categoryArr[i]];
        [_scrollView addSubview:[(CategoryItemsList *)_categoryArr[i] tableView]];
    }
}

- (void)dealloc
{
    for (int i = 0; i < 7; i++)
        [self removeObserver:_observerArr[i] forKeyPath:@"selectedButtonTag"];
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

- (UIView *)navigationViewInHeaderBar
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, HEADERBARHEIGHT)] autorelease];
    UIView *buttonBkgrd = [[UIView alloc] initWithFrame:CGRectMake(0, HEADERBARHEIGHT * 5 / 9, _viewWidth, HEADERBARHEIGHT * 4 / 9)];
    [headerView addSubview:buttonBkgrd];
    [buttonBkgrd release];
    [buttonBkgrd setBackgroundColor:[UIColor blackColor]];
    for (int i = 0; i < 6; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * _viewWidth / 6, 0, _viewWidth / 6, 40)];
        [button setTag:0x9000 + i];
        [buttonBkgrd addSubview:button];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:14]];
        [button addTarget:self action:@selector(headerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(_viewWidth / 12 - 16.67, HEADERBARHEIGHT * 3 / 9, 33.33, 2)];/*_viewWidth / 6 - 20*/
    [bottom setBackgroundColor:[UIColor whiteColor]];
    [buttonBkgrd addSubview:bottom];
    [self addObserver:bottom forKeyPath:@"selectedButtonTag" options:NSKeyValueObservingOptionNew context:&_viewWidth];
    [_observerArr addObject:bottom];
    [bottom release];
    return headerView;
}

- (void)headerButtonAction:(UIButton *)button
{
    _scrollViewCanResponseToScroll = NO;
    [self setSelectedButtonTag:[NSNumber numberWithInteger:[button tag]]];
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
        if (_scrollViewOldIndex != index)
        {
            [self setSelectedButtonTag:[NSNumber numberWithInteger:index + 0x9000]];
        }
        _scrollViewOldIndex = index;
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

@end

@implementation UIView (Home_Category)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat num = [[change objectForKey:@"new"] integerValue] - 0x9000 + 0.5;
    [UIView animateWithDuration:0.3 animations:^{
        [self setCenter:CGPointMake(num * *(CGFloat *)context / 6, [self center].y)];
    }];
}

@end
