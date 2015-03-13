//
//  CategoryItemsList.m
//  MEI
//
//  Created by Yosemite on 3/5/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "CategoryItemsList.h"
#import "Network_RemoteDataLoad.h"
#import "URLCreate.h"
//#import "ProductsListCell.h"
//#import "CategoryProductsList.h"
#import "CategoryProductsFlow.h"
#import "HeaderFooterManager.h"
#import "SpecialSiloList.h"

#define TABLEFOOTERHEIGHT 50
#define BOTTOMHEIGHT 150
#define CELLIDENTIFIER @"cellid"
#define HEADERIDENTIFIER @"headerid"
#define FOOTERIDENTIFIER @"footerid"

@interface CategoryItemsList ()
{
    Network_RemoteDataLoad *_netWorker;
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    NSInteger _totalPages;
    NSInteger _currentMaxPage;
    
    NSMutableArray *_dataSource;
    NSMutableArray *_bannerArr;
    UIView *_bottomNavigationer;
    NSMutableArray *_specialSilo;
    NSString *_specialSiloImage;
}
@end

@implementation CategoryItemsList

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _viewWidth = [[self tableView] bounds].size.width;
    _viewHeight = [[self tableView] bounds].size.height;
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    _bannerArr = [[NSMutableArray alloc] initWithCapacity:6];
    _specialSilo = [[NSMutableArray alloc] initWithCapacity:0];
    [[self tableView] setBackgroundColor:[UIColor whiteColor]];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setShowsVerticalScrollIndicator:YES];
    [[self tableView] setTableHeaderView:[self tableHeaderView]];
    [[self tableView] setTableFooterView:[self tableFooterViewForLoadData]];
//    [[self tableView] setSectionFooterHeight:0];
    _netWorker = [Network_RemoteDataLoad new];
    _bottomNavigationer = [[HeaderFooterManager getFooterView] retain];
    
    if (_categoryId != 17835)
    {
        UIRefreshControl *refreshControl = [UIRefreshControl new];
        [refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
        NSDictionary *attributeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:12], NSFontAttributeName, nil];
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:@"立即刷新" attributes:attributeDictionary];
        [refreshControl setAttributedTitle:attributeString];
        [self setRefreshControl:refreshControl];
        [refreshControl release];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    [_netWorker release];
    if (_bannerArr)
    {
        [_bannerArr release];
    }
    if (_dataSource)
    {
        [_dataSource release];
    }
    if (_specialSilo)
    {
        [_specialSilo release];
    }
    if (_specialSiloImage)
    {
        [_specialSiloImage release];
    }
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Invalid update: invalid number of rows in section 0.  The number of rows contained in an existing section after the update (20) must be equal to the number of rows contained in that section before the update (10), plus or minus the number of rows inserted or deleted from that section (1 inserted, 1 deleted) and plus or minus the number of rows moved into or out of that section (0 moved in, 0 moved out).
 */
- (void)refreshTableView:(UIRefreshControl *)refreshControl
{
    [[self tableView] setScrollEnabled:NO];
    [refreshControl endRefreshing];
    _currentMaxPage = 0;
    _totalPages = 0;
    [_dataSource removeAllObjects];
    [_bannerArr removeAllObjects];
    [_specialSilo removeAllObjects];
    if (_specialSiloImage)
    {
        [_specialSiloImage release];
        _specialSiloImage = nil;
    }
    if (!_bottomNavigationer)
    {
        _bottomNavigationer = [[HeaderFooterManager getFooterView] retain];
    }
    [[self tableView] setTableFooterView:[self tableFooterViewForLoadData]];
    [[self tableView] reloadData];
    [[self tableView] setScrollEnabled:YES];
    [self loadDataWithPageIndex:1];
}

- (void)loadDataWithPageIndex:(NSInteger)index
{
    NSString *urlStr = [URLCreate getURLWithCategoryId:_categoryId pageIndex:index];
    __block UITableView *tableView = [self tableView];
    NSInteger dataSourceCount = [_dataSource count];
    [_netWorker loadDataIgnoringL1CacheFromURLWithString:urlStr didFinishLoad:^(NSData *data) {
        NSDictionary *jdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        _totalPages = [[jdic objectForKey:@"totalPages"] integerValue];
        if (_categoryId == -1)
        {
            _totalPages = _totalPages > 13 ? 13 : _totalPages;
        }
        if (_categoryId == 12721 || _categoryId == 12722)
        {
            _totalPages = 1;
        }
        else if (_categoryId == 12720)
        {
            _totalPages = _totalPages > 4 ? 4 : _totalPages;;
        }
        else if (_categoryId == 12718)
        {
            _totalPages = _totalPages > 5 ? 5 : _totalPages;;
        }
        else if (_categoryId == 12719)
        {
            _totalPages = _totalPages > 3 ? 3 : _totalPages;
        }
        NSArray *listArr = nil;
        if (_categoryId == -1)//all
        {
            listArr = [jdic objectForKey:@"lists"];
        }
        else if (_categoryId == 17835)//special silo
        {
            listArr = [jdic objectForKey:@"eventList"];
            _totalPages = 1;
        }
        else if (_categoryId < 12750 && _categoryId > 0)
        {
            listArr = [jdic objectForKey:@"eventList"];//silo category
        }
        else if (_categoryId > 17840)/***不再使用***///使用--->>CategoryProductFlow.h
        {
            listArr = [jdic objectForKey:@"products"];
        }
        if (listArr)
        {
            _currentMaxPage++;
            [_dataSource addObjectsFromArray:listArr];
            _specialSiloImage = [[jdic objectForKey:@"templateImageUrl"] retain];
            if (dataSourceCount != 0)
            {
                NSInteger count = [listArr count];
                if (_categoryId < 17840)
                {
                    NSMutableArray *marr = [[NSMutableArray alloc] initWithCapacity:count];
                    for (int i = 0; i < count; i++)
                    {
                        [marr addObject:[NSIndexPath indexPathForRow:dataSourceCount + i inSection:0]];
                    }
                    [tableView insertRowsAtIndexPaths:marr withRowAnimation:UITableViewRowAnimationTop];
                    [marr release];
                }
                else
                {
                    NSInteger dataSourceCount_2 = dataSourceCount / 2;///
                    count = count & 1 ? count / 2 + 1 : count / 2;
                    NSMutableArray *marr = [[NSMutableArray alloc] initWithCapacity:count];
                    for (int i = 0; i < count; i++)
                    {
                        [marr addObject:[NSIndexPath indexPathForRow:dataSourceCount_2 + i inSection:0]];
                    }
                    [tableView insertRowsAtIndexPaths:marr withRowAnimation:UITableViewRowAnimationTop];
                    [marr release];
                }
            }
            else
            {
                [tableView reloadData];
            }
        }
    }];
}

- (UIView *)tableHeaderView
{
    UIView *tableHeader = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, 2)] autorelease];
    [tableHeader setOpaque:YES];
    return tableHeader;
}

- (UIView *)tableFooterViewForLoadData
{
    UIView *tableFooter = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, TABLEFOOTERHEIGHT)] autorelease];
    UIActivityIndicatorView *uavc = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, TABLEFOOTERHEIGHT)];
    [tableFooter addSubview:uavc];
    [uavc release];
    [uavc setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [uavc startAnimating];
    [tableFooter setOpaque:YES];
    return tableFooter;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_categoryId < 17840)
    {
        return _viewWidth * 326 / 640 + 2;
    }
    else///
    {
        CGFloat viewWidth = (_viewWidth - 24) / 2;
        return viewWidth * 1.777778 + 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_categoryId == -1)//全部
    {
        return  _viewWidth * 258 / 640 + _viewWidth * 160 / 640 + _viewWidth * 75 / 640 + 4;
    }
    else if (_categoryId == 17835)//老佛爷奥莱
    {
        return _viewWidth * 768 / 640 + 2;
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_categoryId < 17840)
    {
        [UIView animateWithDuration:0.63 animations:^{
            [[(ItemsListCell *)cell customAnimationView] setFrame:[(ItemsListCell *)cell frameShow]];
            [[(ItemsListCell *)cell customAnimationView] setAlpha:0.6];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (_categoryId < 17840)
    {
        [[(ItemsListCell *)cell customAnimationView] setFrame:[(ItemsListCell *)cell frameHidden]];
        [[(ItemsListCell *)cell customAnimationView] setAlpha:0];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if (_currentMaxPage == 0)
        [self loadDataWithPageIndex:1];
    else
    {
        if (_currentMaxPage == _totalPages && _totalPages != 0)
        {
            if (_bottomNavigationer)
            {
                [tableView setTableFooterView:_bottomNavigationer];
                [_bottomNavigationer release];
                _bottomNavigationer = nil;
            }
        }
        else
        {
            __block CategoryItemsList *obj = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.49 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [obj loadDataWithPageIndex:_currentMaxPage + 1];
            });
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CategoryProductsFlow *productFlow = [CategoryProductsFlow new];
    productFlow->_categoryId = 180001;
    [productFlow setTitle:[_dataSource[[indexPath row]] objectForKey:@"englishName"]];
    [[[self parentViewController] navigationController] pushViewController:productFlow animated:YES];
    [productFlow release];
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([_dataSource count] == 0)
    {
        return nil;
    }
    else if (_categoryId == -1)
    {
        UITableViewHeaderFooterView *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADERIDENTIFIER];
        return [self configureSectionHeader:sectionHeader ofTableView:tableView inSection:section];///!
    }
    else if (_categoryId == 17835)
    {
        if (_specialSiloImage)
        {
            UITableViewHeaderFooterView *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADERIDENTIFIER];
            return [self configureSpecialCategorySectionHeader:sectionHeader];
        }
        else
        {
            return nil;
        }
    }
    else
        return nil;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *sectionFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FOOTERIDENTIFIER];
    if (!sectionFooter)
    {
        sectionFooter = [[[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:FOOTERIDENTIFIER] autorelease];
        [sectionFooter setFrame:CGRectMake(0, 0, _viewWidth, 1)];
        [[sectionFooter contentView] setBackgroundColor:[UIColor whiteColor]];
        [sectionFooter setOpaque:YES];
        return sectionFooter;
    }
    return sectionFooter;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_categoryId < 17840)
    {
        return [_dataSource count];
    }
    else
    {
        NSInteger count = [_dataSource count];
        return count & 1 ? count / 2 + 1 : count / 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_categoryId < 17840)
    {
        ItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
        return [self configureCell:cell ofTableView:tableView atIndexPath:indexPath];
    }
    else if (_categoryId > 17840)
    {
        ProductsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
        return [self configureCell0:cell ofTableView:tableView atIndexPath:indexPath];
    }
    else return [[UITableViewCell new] autorelease];
}

#pragma mark Table view end

- (UITableViewHeaderFooterView *)configureSectionHeader:(UITableViewHeaderFooterView *)sectionHeader ofTableView:(UITableView *)tableView inSection:(NSInteger)section
{
    if (!sectionHeader)
    {//获取并设置Scroll view contentSize
        sectionHeader = [[[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HEADERIDENTIFIER] autorelease];
        [sectionHeader setFrame:CGRectMake(0, 0, _viewWidth, _viewWidth * 258 / 640 + _viewWidth * 160 / 640 + _viewWidth * 75 / 640 + 2)];
        [[sectionHeader contentView] setBackgroundColor:[UIColor whiteColor]];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewWidth * 258 / 640)];//Scroll images: 640x258-DAY2-G3.jpg
        [[sectionHeader contentView] addSubview:scrollView];
        [scrollView release];
        [scrollView setBounces:NO];
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        if ([_bannerArr count] == 0)
        {
            [_netWorker cancelConnectionOfURLWithString:@"http://www.mei.com/appapi/home/marketingBanner?summary=ab37c575dd399d014187f1c8c0d921a9"];
            [_netWorker loadDataIgnoringL1CacheFromURLWithString:@"http://www.mei.com/appapi/home/marketingBanner?summary=ab37c575dd399d014187f1c8c0d921a9" didFinishLoad:^(NSData *data) {
                NSDictionary *jdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSArray *arr = [jdic objectForKey:@"banners"];
                if (arr)
                {
                    [_bannerArr removeAllObjects];
                    [_bannerArr addObjectsFromArray:arr];
                    NSInteger page = 0;
                    for (int i = 0; i < [_bannerArr count]; i++)
                    {
                        if ([[_bannerArr[i] objectForKey:@"imgAndroid"] length] == 0)
                        {
                            page++;
                            __block UIImageView *bannerImage = [[UIImageView alloc] initWithFrame:CGRectMake(i * _viewWidth, 0, _viewWidth, [scrollView bounds].size.height)];
                            [scrollView addSubview:bannerImage];
                            [bannerImage release];
                            [bannerImage setTag:0x7000 + i];
                            __block void (^didFinishLoad)(NSData *);
                            didFinishLoad = ^(NSData *data) {
                                [bannerImage setImage:[UIImage imageWithData:data]];///
                            };
                            [_netWorker loadDataFromURLWithString:[_bannerArr[i] objectForKey:@"imgUrl"] didFinishLoad:didFinishLoad];
                        }
                        
                    }
                    [scrollView setContentSize:CGSizeMake(page * _viewWidth, [scrollView bounds].size.height)];
                }
            }];
        }
        else
        {
            NSInteger page = 0;
            for (int i = 0; i < [_bannerArr count]; i++)
            {
                if ([[_bannerArr[i] objectForKey:@"imgAndroid"] length] == 0)
                {
                    page++;
                    __block UIImageView *bannerImage = [[UIImageView alloc] initWithFrame:CGRectMake(i * _viewWidth, 0, _viewWidth, [scrollView bounds].size.height)];
                    [scrollView addSubview:bannerImage];
                    [bannerImage release];
                    [bannerImage setTag:0x7000 + i];
                    __block void (^didFinishLoad)(NSData *);
                    didFinishLoad = ^(NSData *data) {
                        [bannerImage setImage:[UIImage imageWithData:data]];///
                    };
                    [_netWorker loadDataFromURLWithString:[_bannerArr[i] objectForKey:@"imgUrl"] didFinishLoad:didFinishLoad];
                }
                
            }
            [scrollView setContentSize:CGSizeMake(page * _viewWidth, [scrollView bounds].size.height)];
        }
        //special silo ...//image size 640 x 160
        __block UIButton *specialButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _viewWidth * 258 / 640 + 1, _viewWidth, _viewWidth * 160 / 640)];
        [[sectionHeader contentView] addSubview:specialButton];
        [specialButton release];
        [specialButton addTarget:self action:@selector(specialButtonAction) forControlEvents:UIControlEventTouchUpInside];
        if ([_specialSilo count])
        {
            [_netWorker cancelConnectionOfURLWithString:[_specialSilo[0] objectForKey:@"imageUrl"]];
            [_netWorker loadDataFromURLWithString:[_specialSilo[0] objectForKey:@"imageUrl"] didFinishLoad:^(NSData *data) {
                [specialButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            }];
        }
        else
        {
            [_netWorker cancelConnectionOfURLWithString:@"http://www.mei.com/appapi/silo/specialSilo?summary=ab37c575dd399d014187f1c8c0d921a9"];
            [_netWorker loadDataIgnoringL1CacheFromURLWithString:@"http://www.mei.com/appapi/silo/specialSilo?summary=ab37c575dd399d014187f1c8c0d921a9" didFinishLoad:^(NSData *data) {
                NSDictionary *jdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSArray *arr = [jdic objectForKey:@"lists"];
                if (arr)
                {
                    [_specialSilo addObjectsFromArray:arr];
                    [_netWorker cancelConnectionOfURLWithString:[_specialSilo[0] objectForKey:@"imageUrl"]];
                    [_netWorker loadDataFromURLWithString:[_specialSilo[0] objectForKey:@"imageUrl"] didFinishLoad:^(NSData *data) {
                        [specialButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                    }];
                }
            }];
        }
        //a local image: 640 x 75
        UIImageView *imageViewBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, _viewWidth * 258 / 640 + _viewWidth * 160 / 640 + 2, _viewWidth, _viewWidth * 75 / 640)];
        [imageViewBar setImage:[UIImage imageNamed:@"new_activity@2x.png"]];
        [sectionHeader addSubview:imageViewBar];
        [imageViewBar release];
        return sectionHeader;
    }
    else
    {
        return sectionHeader;
    }
}

- (void)specialButtonAction
{
    if ([_specialSilo count])
    {
        SpecialSiloList *specialSiloList = [SpecialSiloList new];
        [specialSiloList setSpecialSiloTitle:[_specialSilo[0] objectForKey:@"categoryName"]];
        [[self navigationController] pushViewController:specialSiloList animated:YES];
        [specialSiloList release];
    }
}

- (UITableViewHeaderFooterView *)configureSpecialCategorySectionHeader:(UITableViewHeaderFooterView *)sectionHeader//老佛爷奥莱 bar
{
    if (!sectionHeader)
    {
        sectionHeader = [[[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HEADERIDENTIFIER] autorelease];
        //image size: 640 x 768
        [sectionHeader setFrame:CGRectMake(0, 0, _viewWidth, _viewWidth * 768 / 640)];
        __block UIImageView *image = [[UIImageView alloc] initWithFrame:[sectionHeader bounds]];
        [sectionHeader addSubview:image];
        [image release];
        [_netWorker loadDataFromURLWithString:_specialSiloImage didFinishLoad:^(NSData *data) {
            [image setImage:[UIImage imageWithData:data]];
        }];
    }
    return sectionHeader;
}

- (UITableViewCell *)configureCell:(ItemsListCell *)cell ofTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    if (!cell)
    {
        cell = [[[ItemsListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLIDENTIFIER] autorelease];
        [cell setFrameShow:CGRectMake(0.5 * _viewWidth, 0.55 * [self tableView:tableView heightForRowAtIndexPath:indexPath], 0.5 * _viewWidth, 0.4 * [self tableView:tableView heightForRowAtIndexPath:indexPath])];
        [cell setFrameHidden:CGRectMake(_viewWidth, 0.55 * [self tableView:tableView heightForRowAtIndexPath:indexPath], 0.5 * _viewWidth, 0.4 * [self tableView:tableView heightForRowAtIndexPath:indexPath])];
        /*image size: 640 x 326*/
        UIImageView *customImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewWidth * 326 / 640)];
        UIView *animationView = [[UIView alloc] initWithFrame:[cell frameHidden]];
        [cell setCustomImageView:customImg];
        [[cell contentView] addSubview:customImg];
        [cell setCustomAnimationView:animationView];
        [[cell customAnimationView] setBackgroundColor:[UIColor blackColor]];
        [[cell contentView] addSubview:animationView];
        [[cell customAnimationView] setAlpha:0];
        [customImg release];
        [animationView release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.11 * [[cell customAnimationView] bounds].size.height, [[cell customAnimationView] bounds].size.width - 10, 0.26 * [[cell customAnimationView] bounds].size.height)];
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.63 * [[cell customAnimationView] bounds].size.height, [[cell customAnimationView] bounds].size.width - 10, 0.26 * [[cell customAnimationView] bounds].size.height)];
        [cell setCustomTitleLabel:titleLabel];
        [cell setCustomDetailLabel:detailLabel];
        [[cell customAnimationView] addSubview:titleLabel];
        [[cell customAnimationView] addSubview:detailLabel];
        [[cell customTitleLabel] setFont:[UIFont systemFontOfSize:13]];
        [[cell customDetailLabel] setFont:[UIFont systemFontOfSize:12]];
        [[cell customTitleLabel] setTextColor:[UIColor whiteColor]];
        [[cell customDetailLabel] setTextColor:[UIColor whiteColor]];
        [titleLabel release];
        [detailLabel release];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.37 * [[cell customAnimationView] bounds].size.height, [[cell customAnimationView] bounds].size.width - 10, 0.26 * [[cell customAnimationView] bounds].size.height)];
        [cell setCustomNameLabel:nameLabel];
        [[cell customAnimationView] addSubview:nameLabel];
        [[cell customNameLabel] setFont:[UIFont systemFontOfSize:13]];
        [[cell customNameLabel] setTextColor:[UIColor whiteColor]];
        [nameLabel release];
    }
    NSInteger index = [indexPath row];
    __block UIImageView *uimgv = [cell customImageView];
    [uimgv setImage:nil];
    [_netWorker loadDataFromURLWithString:[_dataSource[index] objectForKey:@"imageUrl"] didFinishLoad:^(NSData *data) {
        [uimgv setImage:[UIImage imageWithData:data]];
    }];
    [[cell customTitleLabel] setText:[_dataSource[index] objectForKey:@"englishName"]];
    [[cell customNameLabel] setText:[_dataSource[index] objectForKey:@"chineseName"]];
    [[cell customDetailLabel] setText:[_dataSource[index] objectForKey:@"discountText"]];
    return cell;
}

#define INTERVAL 4
- (UITableViewCell *)configureCell0:(ProductsListCell *)cell ofTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    if (!cell)
    {
        CGFloat rowHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        CGFloat viewWidth = (_viewWidth - 6 * INTERVAL) / 2;
        CGFloat viewHeight = rowHeight - 2 * INTERVAL;
        cell = [[[ProductsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDENTIFIER] autorelease];
        [[cell contentView] setBackgroundColor:[UIColor colorWithWhite:0.92 alpha:1.0]];
        
        CellView *leftView = [[CellView alloc] initWithFrame:CGRectMake(2 * INTERVAL, INTERVAL, viewWidth, viewHeight)];
        [cell setLeftView:leftView];
        CellView *rightView = [[CellView alloc] initWithFrame:CGRectMake(4 * INTERVAL + viewWidth, INTERVAL, viewWidth, viewHeight)];
        [cell setRightView:rightView];
        [[cell contentView] addSubview:leftView];
        [[cell contentView] addSubview:rightView];
        [leftView release];
        [rightView release];
        CellView *view = [cell leftView];
        for (int i = 0; i < 2; i++)
        {
            if (i == 1)
                view = [cell rightView];
            [view setBackgroundColor:[UIColor whiteColor]];
            UIImageView *imageShow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 0.75 * viewHeight)];
            UILabel *brandName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.75 * viewHeight, viewWidth, viewHeight / 16)];
            UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.8125 * viewHeight, viewWidth, viewHeight / 16)];
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.872 * viewHeight, viewWidth, 0.1 * viewWidth)];
            UILabel *marketPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.872 * viewHeight, viewWidth, 0.1 * viewWidth)];
            [view setImageShow:imageShow];
            [view setBrandName:brandName];
            [view setProductName:productName];
            [view setPrice:priceLabel];
            [view setMarketPrice:marketPriceLabel];
            [view addSubview:imageShow];
            [view addSubview:brandName];
            [view addSubview:productName];
            [view addSubview:priceLabel];
            [view addSubview:marketPriceLabel];
            [imageShow release];
            [brandName release];
            [productName release];
            [priceLabel release];
            [marketPriceLabel release];
        }
    }
    NSInteger index = [indexPath row] * 2;
    [[[cell leftView] brandName] setText:[_dataSource[index] objectForKey:@"brandName"]];
    [[[cell leftView] productName] setText:[_dataSource[index] objectForKey:@"productName"]];
    [[[cell leftView] price] setText:[_dataSource[index] objectForKey:@"price"]];
    [[[cell leftView] marketPrice] setText:[_dataSource[index] objectForKey:@"marketPrice"]];
    [_netWorker loadDataFromURLWithString:[_dataSource[index] objectForKey:@"imageUrl"] didFinishLoad:^(NSData *data) {
        [[[cell leftView] imageShow] setImage:[UIImage imageWithData:data]];
    }];
    if (++index < [_dataSource count])
    {
        [[[cell rightView] brandName] setText:[_dataSource[index] objectForKey:@"brandName"]];
        [[[cell rightView] productName] setText:[_dataSource[index] objectForKey:@"productName"]];
        [[[cell rightView] price] setText:[_dataSource[index] objectForKey:@"price"]];
        [[[cell rightView] marketPrice] setText:[_dataSource[index] objectForKey:@"marketPrice"]];
        [_netWorker loadDataFromURLWithString:[_dataSource[index] objectForKey:@"imageUrl"] didFinishLoad:^(NSData *data) {
            [[[cell rightView] imageShow] setImage:[UIImage imageWithData:data]];
        }];
    }
    else
    {
        
        [[[cell rightView] brandName] setText:nil];
        [[[cell rightView] productName] setText:nil];
        [[[cell rightView] price] setText:nil];
        [[[cell rightView] marketPrice] setText:nil];
        [[[cell rightView] imageShow] setImage:nil];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Scroll view delegate

@end

@implementation ItemsListCell

- (void)dealloc
{
    [self setCustomAnimationView:nil];
    [self setCustomTitleLabel:nil];
    [self setCustomNameLabel:nil];
    [self setCustomDetailLabel:nil];
    [self setCustomAnimationView:nil];
    [super dealloc];
}

@end

@implementation ProductsListCell

- (void)dealloc
{
    [self setLeftView:nil];
    [self setRightView:nil];
    [super dealloc];
}

@end

@implementation CellView

- (void)dealloc
{
    [self setImageShow:nil];
    [self setProductName:nil];
    [self setMarketPrice:nil];
    [self setPrice:nil];
    [self setBrandName:nil];
    [super dealloc];
}

@end
