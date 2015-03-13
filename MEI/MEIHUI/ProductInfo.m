//
//  ProductInfo.m
//  MEI
//
//  Created by Yosemite on 3/10/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "ProductInfo.h"
#import "Network_RemoteDataLoad.h"
#import "HeaderFooterManager.h"

@interface ProductInfo ()
{
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    CGFloat _headerHeight;
    NSMutableDictionary *_dataSource;
    Network_RemoteDataLoad *_netWorker;
    
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    UILabel *_description;
}
@end

@implementation ProductInfo

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewWidth = [[self view] bounds].size.width;
    _viewHeight = [[self view] bounds].size.height;
    _headerHeight = (0.220689 - 0.02) * _viewHeight;
    _dataSource = [[NSMutableDictionary alloc] initWithCapacity:1];
    _netWorker = [Network_RemoteDataLoad new];
    [[self view] setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    [HeaderFooterManager setWindowHeaderViewForViewController:self withHeaderStyle:headerWithBackAndShoppingBasket withTitle:@"商品详情"];
    UIImageView *upline = [[UIImageView alloc] initWithFrame:CGRectMake(0, _headerHeight * 0.61, _viewWidth, 1)];
    [upline setImage:[UIImage imageNamed:@"line_ord@2x.png"]];
    [[self view] addSubview:upline];
    [upline release];
    //720 x 960, 225 x 300..0.75
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _headerHeight * 0.61 + 0.5, _viewWidth, _viewWidth)];//是一个正方形
    [[self view] addSubview:scrollView];
    [scrollView release];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [scrollView setContentSize:CGSizeMake(_viewWidth, [scrollView bounds].size.height)];
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setDelegate:self];
    _scrollView = scrollView;
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.4 * _viewWidth, [scrollView frame].origin.y + 0.9 * [scrollView bounds].size.height, 0.2 * _viewWidth, 0.1 * [scrollView bounds].size.height)];
    [[self view] addSubview:pageControl];
    [pageControl release];
    [pageControl setHidesForSinglePage:YES];
    [pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    _pageControl = pageControl;
    UIImageView *bottomline = [[UIImageView alloc] initWithFrame:CGRectMake(0, [scrollView frame].origin.y + [scrollView bounds].size.height, _viewWidth, 1)];
    [bottomline setImage:[UIImage imageNamed:@"line_ord@2x.png"]];
    [[self view] addSubview:bottomline];
    [bottomline release];
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(0, [scrollView frame].origin.y + [scrollView bounds].size.height + 2, _viewWidth, 0.15 * _viewHeight)];
    [description setBackgroundColor:[UIColor whiteColor]];
    [[self view] addSubview:description];
    [description release];
    [description setFont:[UIFont systemFontOfSize:15]];
    [description setNumberOfLines:2];
    _description = description;
    UIButton *addToBasket = [[UIButton alloc] initWithFrame:CGRectMake(0.3 * _viewWidth, 0.875 * _viewHeight, 0.4 * _viewWidth, 0.07 * _viewHeight)];
    [[self view] addSubview:addToBasket];
    [addToBasket release];
    [addToBasket setTitle:@"加入购物袋" forState:UIControlStateNormal];
    [addToBasket setBackgroundImage:[UIImage imageNamed:@"button_red_big2.png"] forState:UIControlStateNormal];
    [addToBasket addTarget:self action:@selector(addToShoppingBasket) forControlEvents:UIControlEventTouchUpInside];
    [self loadData];
}

- (void)dealloc
{
    [_dataSource release];
    [_netWorker release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    [_netWorker loadDataIgnoringL1CacheFromURLWithString:@"http://www.mei.com/appapi/product/detail?categoryId=18905&productId=767425&summary=6796d838bdc68de61aae19b2171ce07a" didFinishLoad:^(NSData *data) {
        NSDictionary *jdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *infos = [jdic objectForKey:@"infos"];
        if (infos)
        {
            _dataSource = [[NSMutableDictionary alloc] initWithDictionary:infos];
            [self dataPrepared];
        }
    }];
}

- (void)dataPrepared
{
    NSArray *images = [_dataSource objectForKey:@"images"];
    [_scrollView setContentSize:CGSizeMake([images count] * _viewWidth, [_scrollView bounds].size.height)];
    [_pageControl setNumberOfPages:[images count]];
    [_pageControl setCurrentPage:0];
    for (int i = 0; i < [images count]; i++)
    {
        __block UIImageView *imageShow = [[UIImageView alloc] initWithFrame:CGRectMake(i * _viewWidth, 0, _viewWidth, _viewWidth)];
        [_scrollView addSubview:imageShow];
        [imageShow release];
        [imageShow setContentMode:UIViewContentModeScaleAspectFit];
        UIButton *buttonToShowBigImage = [[UIButton alloc] initWithFrame:CGRectMake(i * _viewWidth, 0, _viewWidth, _viewWidth)];
        [_scrollView addSubview:buttonToShowBigImage];
        [buttonToShowBigImage setTag:i];
        [buttonToShowBigImage release];
        [buttonToShowBigImage addTarget:self action:@selector(showBigImage:) forControlEvents:UIControlEventTouchUpInside];
        [_netWorker loadDataFromURLWithString:[images[i] objectForKey:@"smallImgUrl"] didFinishLoad:^(NSData *data) {
            [imageShow setImage:[UIImage imageWithData:data]];
        }];
    }
    [_description setText:[NSString stringWithFormat:@"    %@\n    %@", [_dataSource objectForKey:@"brand"], [_dataSource objectForKey:@"name"]]];
}

- (void)showBigImage:(UIButton *)button
{
    NSString *imgUrl =  [[_dataSource objectForKey:@"images"][[button tag]] objectForKey:@"bigImgUrl"];
    __block UIView *view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [view setBackgroundColor:[UIColor whiteColor]];
    UIActivityIndicatorView *uai = [[UIActivityIndicatorView alloc] initWithFrame:[view bounds]];
    [uai setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [view addSubview:uai];
    [uai startAnimating];
    [uai release];
    UIImageView *bigImage = [[UIImageView alloc] initWithFrame:[view bounds]];
    [view addSubview:bigImage];
    [bigImage release];
    [bigImage setContentMode:UIViewContentModeScaleAspectFit];
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonBack setFrame:[view bounds]];
    [view addSubview:buttonBack];
    [buttonBack setTag:(NSInteger)view];
    [buttonBack addTarget:self action:@selector(backFromBigImage:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationTransition:5 forView:[self view] cache:YES];
        [[self view] addSubview:view];
    }];
    [_netWorker loadDataFromURLWithString:imgUrl didFinishLoad:^(NSData *data) {
        [bigImage setImage:[UIImage imageWithData:data]];
    }];
}

- (void)backFromBigImage:(UIButton *)button
{
    __block UIView *view = (UIView *)[button tag];
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationTransition:5 forView:[self view] cache:YES];
        [view removeFromSuperview];
    }];
}

- (void)addToShoppingBasket
{
    
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
    CGFloat x = [scrollView contentOffset].x;
    NSInteger page = x / _viewWidth + 0.5;
    [_pageControl setCurrentPage:page];
}

@end
