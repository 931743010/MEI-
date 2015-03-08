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
#import "ItemsListCell.h"
#import "CategoryProductsList.h"
#define TABLEFOOTERHEIGHT 50
#define EXTSECHEAHEI 30
#define BOTTOMHEIGHT 150

@interface CategoryItemsList ()
{
    Network_RemoteDataLoad *_netWorker;
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    NSInteger _totalPages;
    NSInteger _currentMaxPage;
    NSString *_cellIdentifier;
    NSString *_secHeaIdentifier;
    NSString *_secFooIdentifier;
    NSInteger _currentRow;
    NSMutableArray *_dataSource;
    NSMutableArray *_bannerArr;
    UIView *_bottomNavigationer;
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
    _cellIdentifier = [@"BNCSDBCHJISDBJ" retain];
    _secHeaIdentifier = [@"SECHEANJSD" retain];
    _secFooIdentifier = [@"SECFOONKLDSN" retain];
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    _bannerArr = [[NSMutableArray alloc] initWithCapacity:6];
    [[self tableView] setBounces:NO];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setShowsVerticalScrollIndicator:YES];
    [[self tableView] setTableHeaderView:[self tableHeaderView]];
    [[self tableView] setTableFooterView:[self tableFooterView]];
    _netWorker = [Network_RemoteDataLoad new];
    _bottomNavigationer = [[self tableFooterWhenScrollToEnd] retain];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    [_dataSource release];
    [_bannerArr release];
    [_netWorker release];
    [_cellIdentifier release];
    [_secHeaIdentifier release];
    [_secFooIdentifier release];
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
- (void)loadDataWithPageIndex:(NSInteger)index
{
    NSString *urlStr = [URLCreate getURLWithCategoryId:_categoryId pageIndex:index];
    __block UITableView *tableView = [self tableView];
    NSInteger currentRowNum = [_dataSource count];
    [_netWorker loadDataIgnoringL1CacheFromURLWithString:urlStr didFinishLoad:^(NSData *data) {
        NSDictionary *jdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        _totalPages = [[jdic objectForKey:@"totalPages"] integerValue] > 11 ? 11 : [[jdic objectForKey:@"totalPages"] integerValue];
        NSArray *listArr = _categoryId == -1 ? listArr = [jdic objectForKey:@"lists"] : [jdic objectForKey:@"eventList"] ;
        if (listArr)
        {
            _currentMaxPage++;
            [_dataSource addObjectsFromArray:listArr];
            if (currentRowNum != 0)
            {
                NSMutableArray *marr = [[NSMutableArray alloc] initWithCapacity:[listArr count]];
                for (int i = 0; i < [listArr count]; i++)
                {
                    [marr addObject:[NSIndexPath indexPathForRow:currentRowNum + i inSection:0]];
                }
                [tableView insertRowsAtIndexPaths:marr withRowAnimation:UITableViewRowAnimationTop];
                [marr release];
            }
            else
                [tableView reloadData];
        }
    }];
}

- (UIView *)tableHeaderView
{
    UIView *tableHeader = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, 2)] autorelease];
    [tableHeader setOpaque:YES];
    return tableHeader;
}

- (UIView *)tableFooterView
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

- (UIView *)tableFooterWhenScrollToEnd
{
    UIView *tableFooter = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewHeight, BOTTOMHEIGHT)] autorelease];
    [tableFooter setBackgroundColor:[UIColor whiteColor]];
    TableFooterView *view = [[TableFooterView alloc] initWithFrame:CGRectMake(0, 20, _viewWidth, BOTTOMHEIGHT - 20)];
    [tableFooter addSubview:view];
    [view release];
    [view setDelegate:self];
    return tableFooter;
}

- (void) buttonDidTouchUpInside:(UIButton *)button
{
    
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _viewWidth * 326 / 640 + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_categoryId == -1)
        return _viewWidth * 258 / 640 + EXTSECHEAHEI;
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.6 animations:^{
        [[(ItemsListCell *)cell customAnimationView] setFrame:[(ItemsListCell *)cell frameShow]];
        [[(ItemsListCell *)cell customAnimationView] setAlpha:0.6];
    }];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [[(ItemsListCell *)cell customAnimationView] setFrame:[(ItemsListCell *)cell frameHidden]];
    [[(ItemsListCell *)cell customAnimationView] setAlpha:0];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if (_currentMaxPage == 0)
        [self loadDataWithPageIndex:_currentMaxPage + 1];
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
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_categoryId == -1)
    {
        UITableViewHeaderFooterView *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:_secHeaIdentifier];
        return [self configureSectionHeader:sectionHeader ofTableView:tableView inSection:section];
    }
    else
        return nil;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *sectionFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:_secFooIdentifier];
    if (!sectionFooter)
    {
        sectionFooter = [[[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:_secFooIdentifier] autorelease];
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
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    return [self configureCell:cell ofTableView:tableView atIndexPath:indexPath];
}

#pragma mark Table view end

- (UITableViewHeaderFooterView *)configureSectionHeader:(UITableViewHeaderFooterView *)sectionHeader ofTableView:(UITableView *)tableView inSection:(NSInteger)section
{
    if (!sectionHeader)
    {
        sectionHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:_secHeaIdentifier];
        [sectionHeader setFrame:CGRectMake(0, 0, _viewWidth, _viewWidth * 258 / 640 + EXTSECHEAHEI)];
        [[sectionHeader contentView] setBackgroundColor:[UIColor grayColor]];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewWidth * 258 / 640)];//640x258-DAY2-G3.jpg
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
                    [scrollView setContentSize:CGSizeMake([_bannerArr count] * _viewWidth, [scrollView bounds].size.height)];
                    for (int i = 0; i < [_bannerArr count]; i++)
                    {
                        __block UIImageView *bannerImage = [[UIImageView alloc] initWithFrame:CGRectMake(i * _viewWidth, 0, _viewWidth, [scrollView bounds].size.height)];
                        [scrollView addSubview:bannerImage];
                        [bannerImage release];
                        [bannerImage setTag:0x7000 + i];
                        [_netWorker loadDataFromURLWithString:[_bannerArr[i] objectForKey:@"imgUrl"] didFinishLoad:^(NSData *data) {
                            [bannerImage setImage:[UIImage imageWithData:data]];
                        }];
                    }
                }
            }];
        }
        else
        {
            [scrollView setContentSize:CGSizeMake([_bannerArr count] * _viewWidth, [scrollView bounds].size.height)];
            for (int i = 0; i < [_bannerArr count]; i++)
            {
                __block UIImageView *bannerImage = [[UIImageView alloc] initWithFrame:CGRectMake(i * _viewWidth, 0, _viewWidth, [scrollView bounds].size.height)];
                [scrollView addSubview:bannerImage];
                [bannerImage release];
                [bannerImage setTag:0x7000 + i];
                [_netWorker cancelConnectionOfURLWithString:[_bannerArr[i] objectForKey:@"imgUrl"]];
                [_netWorker loadDataFromURLWithString:[_bannerArr[i] objectForKey:@"imgUrl"] didFinishLoad:^(NSData *data) {
                    [bannerImage setImage:[UIImage imageWithData:data]];
                }];
            }
        }
    }
    return sectionHeader;
}

- (UITableViewCell *)configureCell:(ItemsListCell *)cell ofTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    if (!cell)
    {
        cell = [[[ItemsListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_cellIdentifier] autorelease];
        [cell setFrameShow:CGRectMake(0.5 * _viewWidth, 0.55 * [self tableView:tableView heightForRowAtIndexPath:indexPath], 0.5 * _viewWidth, 0.4 * [self tableView:tableView heightForRowAtIndexPath:indexPath])];
        [cell setFrameHidden:CGRectMake(_viewWidth, 0.55 * [self tableView:tableView heightForRowAtIndexPath:indexPath], 0.5 * _viewWidth, 0.4 * [self tableView:tableView heightForRowAtIndexPath:indexPath])];
        /*image size: 640 x 326*/
        [cell setCustomImageView:[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewWidth * 326 / 640)]];
        [[cell contentView] addSubview:[cell customImageView]];
        [cell setCustomAnimationView:[[UIView alloc] initWithFrame:[cell frameHidden]]];
        [[cell customAnimationView] setBackgroundColor:[UIColor blackColor]];
        [[cell contentView] addSubview:[cell customAnimationView]];
        [[cell customAnimationView] setAlpha:0];
        
        [cell setCustomTitleLabel:[[UILabel alloc] initWithFrame:CGRectMake(10, 0.11 * [[cell customAnimationView] bounds].size.height, [[cell customAnimationView] bounds].size.width - 10, 0.26 * [[cell customAnimationView] bounds].size.height)]];
        [cell setCustomDetailLabel:[[UILabel alloc] initWithFrame:CGRectMake(10, 0.63 * [[cell customAnimationView] bounds].size.height, [[cell customAnimationView] bounds].size.width - 10, 0.26 * [[cell customAnimationView] bounds].size.height)]];
        [[cell customAnimationView] addSubview:[cell customTitleLabel]];
        [[cell customAnimationView] addSubview:[cell customDetailLabel]];
        [[cell customTitleLabel] setFont:[UIFont systemFontOfSize:13]];
        [[cell customDetailLabel] setFont:[UIFont systemFontOfSize:12]];
        [[cell customTitleLabel] setTextColor:[UIColor whiteColor]];
        [[cell customDetailLabel] setTextColor:[UIColor whiteColor]];
        
        [cell setCustomNameLabel:[[UILabel alloc] initWithFrame:CGRectMake(10, 0.37 * [[cell customAnimationView] bounds].size.height, [[cell customAnimationView] bounds].size.width - 10, 0.26 * [[cell customAnimationView] bounds].size.height)]];
        [[cell customAnimationView] addSubview:[cell customNameLabel]];
        [[cell customNameLabel] setFont:[UIFont systemFontOfSize:13]];
        [[cell customNameLabel] setTextColor:[UIColor whiteColor]];
        
        [[cell customNameLabel] release];
        [[cell customImageView] release];
        [[cell customAnimationView] release];
        [[cell customTitleLabel] release];
        [[cell customDetailLabel] release];
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
