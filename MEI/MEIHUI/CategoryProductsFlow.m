//
//  CategoryProductsFlow.m
//  MEI
//
//  Created by Yosemite on 3/8/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "CategoryProductsFlow.h"
#import "Network_RemoteDataLoad.h"
#import "URLCreate.h"
#import "ProductInfo.h"
#import "HeaderFooterManager.h"

@interface CategoryProductsFlow ()
{
    NSMutableArray *_dataSource;
    __block MyFlow *_myFlow_products;
    Network_RemoteDataLoad *_netWorker;
    CGFloat _viewHeight;
    //header view
    CGFloat _viewWidth;
    CGFloat _headerHeight;
}
@property (nonatomic, copy) __block NSString *startTime;
@property (nonatomic, copy) __block NSString *endTime;
@property (nonatomic, copy) __block NSString *advertisement;
@end

#define EDGEINTERVAL 10
@implementation CategoryProductsFlow

- (void)viewDidLoad
{
    _viewWidth = [[UIScreen mainScreen] bounds].size.width;
    _headerHeight = (0.220689 - 0.02) * [[UIScreen mainScreen] bounds].size.height;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setAutomaticallyAdjustsScrollViewInsets:NO];///
    _viewHeight = [[self view] bounds].size.height;
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    _netWorker = [Network_RemoteDataLoad new];
    CGFloat width = [[self view] bounds].size.width;
    CGFloat height = [[self view] bounds].size.height;
    [HeaderFooterManager setWindowHeaderViewForViewController:self withHeaderStyle:headerWithBackAndShoppingBasket withTitle:[self title]];
    _myFlow_products = [[MyFlow alloc] initWithFrame:CGRectMake(0, 0.61 * (0.220689 - 0.02) * height, width, (1 - 0.61 * (0.220689 - 0.02)) * height)];
    [[self view] addSubview:_myFlow_products];
    [_myFlow_products setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [_myFlow_products setMyFlowDelegate:self];
    [_myFlow_products setCellWidth:([[self view] bounds].size.width - 3 * EDGEINTERVAL) / 2];
    [_myFlow_products setCellHeight:1.777778 * [_myFlow_products cellWidth]];
    [_myFlow_products setDataSource:_dataSource];
    [_myFlow_products setFooterHeight:150];
    [_myFlow_products setFooterView:[HeaderFooterManager getFooterView]];
    [_myFlow_products setCellYCoordinateOffset:3.5 * 0.39 * (0.220689 - 0.02) * _viewHeight];
    [self loadData];
}

- (UIView *)launchDateView
{
    UILabel *endTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.5, [[self view] bounds].size.width, 0.39 * (0.220689 - 0.02) * _viewHeight)];
    NSInteger time = [_endTime integerValue];
    NSDate *date = [NSDate date];
    NSDate *date1970 = [NSDate dateWithTimeIntervalSince1970:0];
    NSInteger interval = [date timeIntervalSinceDate:date1970];
    time -= interval;
    NSInteger day = time / 86400;
    time -= day * 86400;
    NSInteger hour = time / 3600;
    time -= hour * 3600;
    NSInteger minute = time / 60;
    [endTime setText:[NSString stringWithFormat:@"%ld天%ld时%ld分后结束", (long)day, (long)hour, (long)minute]];
    [endTime setBackgroundColor:[UIColor whiteColor]];
    [endTime setTextAlignment:NSTextAlignmentCenter];
    return [endTime autorelease];
}

- (UIView *)descriptionView
{
    UIView *bkgrd = [[UIView alloc] initWithFrame:CGRectMake(0, 0.39 * (0.220689 - 0.02) * _viewHeight + 1.5/*2*/, [[self view] bounds].size.width, 2.5 * 0.39 * (0.220689 - 0.02) * _viewHeight - 2)];
    [bkgrd setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, [bkgrd bounds].size.width - 40, [bkgrd bounds].size.height - 20)];
    [bkgrd addSubview:label];
    [label release];
    [label setText:[NSString stringWithFormat:@"%@", _advertisement]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor blackColor]];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:14]];
    return [bkgrd autorelease];
}

- (void)loadData
{
    __block CategoryProductsFlow *obj = self;
    NSString *URLStr = [URLCreate getURLWithCategoryId:_categoryId pageIndex:0];
    [_netWorker loadDataIgnoringL1CacheFromURLWithString:URLStr didFinishLoad:^(NSData *data) {
        NSDictionary *jdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *arr = [jdic objectForKey:@"products"];
        if (arr)
        {
            [obj setStartTime:[jdic objectForKey:@"startTime"]];
            [obj setEndTime:[jdic objectForKey:@"endTime"]];
            [obj setAdvertisement:[[jdic objectForKey:@"promotions" ] objectForKey:@"info"]];
            [_dataSource addObjectsFromArray:arr];
            for (int i = 0; i < 3; i++)
            {
                [_dataSource addObjectsFromArray:arr];
            }
            [_myFlow_products addSubview:[obj launchDateView]];
            [_myFlow_products addSubview:[self descriptionView]];
            [_myFlow_products reloadData];
        }
    }];
}

- (void)dealloc
{
    [_netWorker release];
    [_myFlow_products release];
    [_dataSource release];
    [_dataSource release];
    [self setStartTime:nil];
    [self setEndTime:nil];
    [self setAdvertisement:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)myFlow:(MyFlow *)myFlow didSelectedCellAtIndex:(NSInteger)index
{
    ProductInfo *productInfo = [ProductInfo new];
    [[self navigationController] pushViewController:productInfo animated:YES];
    [productInfo release];
}

- (FlowCell *)myFlow:(MyFlow *)myFlow configureCell:(FlowCell *)cell ForIndex:(NSInteger)index
{
    [[cell brandName] setText:[_dataSource[index] objectForKey:@"brandName"]];
    [[cell productName] setText:[_dataSource[index] objectForKey:@"productName"]];
    [[cell price] setText:[NSString stringWithFormat:@"¥%ld", (long)[[_dataSource[index] objectForKey:@"price"] integerValue]]];
    
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:1], NSStrikethroughStyleAttributeName, nil];
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%ld", (long)[[_dataSource[index] objectForKey:@"marketPrice"] integerValue]] attributes:attr];
    [[cell marketPrice] setAttributedText:attributedStr];
    [attributedStr release];
    UIImageView *image = [cell imageShow];
    [_netWorker loadDataFromURLWithString:[_dataSource[index] objectForKey:@"imageUrl"] didFinishLoad:^(NSData *data) {
        [image setImage:[UIImage imageWithData:data]];
    }];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
