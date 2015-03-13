//
//  UpComingList.m
//  MEI
//
//  Created by Yosemite on 3/10/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "UpComingList.h"
#import "Network_RemoteDataLoad.h"
#import "HeaderFooterManager.h"

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
#define INTEGERSIZE 8
#define MASKLOW 0x00000000ffffffff
#define MASKHIGH 0xffffffff00000000
#else
#define INTEGERSIZE 4
#define MASKLOW 0x0000ffff
#define MASKHIGH 0xffff0000
#endif

@interface UpComingList ()
{
    NSMutableArray *_dataSource;
    NSMutableArray *_titlesArr;
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    CGFloat _cellHeight;
    Network_RemoteDataLoad *_netWorker;
    
    NSMutableArray *_observerArr;
    NSInteger _theSection;
    BOOL _isUserDragging;
}
@property (nonatomic, assign) NSInteger selectedButtonTag_Upcoming;
@end

@implementation UpComingList

- (void)viewDidLoad
{
    [super viewDidLoad];
    _viewWidth = [[self tableView] bounds].size.width;
    _viewHeight = [[self tableView] bounds].size.height;
    //cell背景图片：179 x 588
    _cellHeight = 0.92 * _viewWidth * 179 / 588;/// + 3
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _observerArr = [[NSMutableArray alloc] initWithCapacity:6];
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    _titlesArr = [[NSMutableArray alloc] initWithCapacity:0];
    _netWorker = [Network_RemoteDataLoad new];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    [[self tableView] setTableHeaderView:[self tableHeader]];
    [[self tableView] setTableFooterView:[HeaderFooterManager getFooterView]];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *attributeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:12], NSFontAttributeName, nil];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:@"立即刷新" attributes:attributeDictionary];
    [refreshControl setAttributedTitle:attributeString];
    [self setRefreshControl:refreshControl];
    [refreshControl release];
    
    [self loadData];
}

- (void)dealloc
{
    for (int i = 0; i < 6; i++)
    {
        [self removeObserver:_observerArr[i] forKeyPath:@"selectedButtonTag"];
    }
    [_observerArr release];
    [_dataSource release];
    [_titlesArr release];
    [_netWorker release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableHeader
{
    UILabel *header = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, 40)] autorelease];
    [header setBackgroundColor:[UIColor whiteColor]];
    [header setText:@"订阅您喜欢的品牌，我们将在活动当天提醒您!"];
    [header setFont:[UIFont systemFontOfSize:13]];
    [header setTextAlignment:NSTextAlignmentCenter];
    return header;
}

- (void)refreshTableView:(UIRefreshControl *)refreshControl
{
    [[self tableView] setScrollEnabled:NO];
    [refreshControl endRefreshing];
    [_dataSource removeAllObjects];
    [_dataSource removeAllObjects];
    [_titlesArr removeAllObjects];
    [[self tableView] reloadData];
    [[self tableView] setScrollEnabled:YES];
    [self loadData];
}

- (void)loadData
{
    __block UpComingList *obj = self;
    [_netWorker loadDataIgnoringL1CacheFromURLWithString:@"http://www.mei.com/appapi/upcoming/index?summary=ab37c575dd399d014187f1c8c0d921a9" didFinishLoad:^(NSData *data) {
        NSDictionary *jdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *titles = [jdic objectForKey:@"titles"];
        NSArray *lists = [jdic objectForKey:@"lists"];
        if (titles && lists)
        {
            for (int i = 0; i < [lists count]; i++)
            {
                [_titlesArr addObject:[lists[i] objectForKey:@"title"]];
            }
            if ([titles count] == [lists count] || YES)///服务器返回的数据并不总是正确的，比如有时会返回两个“后天”。此判断无意义。
            {
                [_dataSource addObjectsFromArray:lists];
                [self navigationBarLayout];
                [self setSelectedButtonTag_Upcoming:0x9500];
                [[obj tableView] reloadData];
            }
        }
    }];
}

- (void)navigationBarLayout//配置导航Button，数目及标题。
{
    UIView *backgroundView = [self navigationBarView];
    for (int i = 0; i < [_dataSource count]; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * _viewWidth / [_dataSource count], 0, _viewWidth / [_dataSource count], [backgroundView bounds].size.height)];
        [button setTag:0x9500 + i];
        [backgroundView addSubview:button];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:14]];
        [button addTarget:self action:@selector(headerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addObserver:button forKeyPath:@"selectedButtonTag_Upcoming" options:NSKeyValueObservingOptionNew context:nil];
        [_observerArr addObject:button];
        [button release];
        [button setTitle:_titlesArr[i] forState:UIControlStateNormal];
    }
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(_viewWidth / 2 * [_titlesArr count] - 16.5, 0.8 * [backgroundView bounds].size.height, 33, 2)];/*_viewWidth / 6 - 20*/
    [bottom setBackgroundColor:[UIColor whiteColor]];
    [bottom setTag:[_dataSource count]];
    [backgroundView addSubview:bottom];
    [self addObserver:bottom forKeyPath:@"selectedButtonTag_Upcoming" options:NSKeyValueObservingOptionNew context:&_viewWidth];
    [_observerArr addObject:bottom];
    [bottom release];
}

- (void)headerButtonAction:(UIButton *)button
{
    _isUserDragging = NO;
    [self setSelectedButtonTag_Upcoming:[button tag]];
    [[self tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[button tag] - 0x9500] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - Table view delagate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight + 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView)
    {
        headerView = [[[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"] autorelease];
        //640 x 46
        CGFloat height = _viewWidth * 46 / 640;
        UIImageView *bkgrd = [[UIImageView alloc] initWithFrame:CGRectMake(0, (40 - height) / 2, _viewWidth, height)];
        [bkgrd setImage:[UIImage imageNamed:@"time_upcoming3_1@2x.png"]];
        [[headerView contentView] addSubview:bkgrd];
        [bkgrd release];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.11 * _viewWidth, 0, 0.89 * _viewHeight, 40)];
        [[headerView contentView] addSubview:label];
        [label release];
        [label setTag:0x800];
        [label setFont:[UIFont systemFontOfSize:11]];
    }
    NSInteger launchTime = [[_dataSource[section] objectForKey:@"launchTime"] integerValue];
    NSInteger hour = launchTime / 3600;
    UILabel *label = (UILabel *)[[headerView contentView] viewWithTag:0x800];
    [label setText:[NSString stringWithFormat:@"%@%ld:00 ", _titlesArr[section], (long)hour]];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    if (!footerView)
    {
        footerView = [[[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footer"] autorelease];
    }
    return footerView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    _theSection = section;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isUserDragging)
    {
        if ([indexPath section] == _theSection)
        {
            self.selectedButtonTag_Upcoming = 0x9500 + _theSection;
        }
        else if ([indexPath section] > _theSection)
        {
            self.selectedButtonTag_Upcoming = 0x9500 + [indexPath section];
        }
        else
        {
            self.selectedButtonTag_Upcoming = 0x9500 + _theSection - 1;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [_titlesArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [[_dataSource[section] objectForKey:@"events"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UpComingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpComing"];
    
    // Configure the cell...
    if (!cell)
    {
        cell = [[[UpComingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UpComing"] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [[cell contentView] setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        /*588 x 179*/
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0.037 * _viewWidth, 0, 1, _cellHeight + 3)];//0.037
        [line setImage:[UIImage imageNamed:@"top_line@2x.png"]];
        [[cell contentView] addSubview:line];
        [line release];
        [line setAlpha:0.5];
        UIImageView *bkgrd = [[UIImageView alloc] initWithFrame:CGRectMake(0.08 * _viewWidth, 0, 0.926 * _viewWidth, _cellHeight)];
        [bkgrd setImage:[UIImage imageNamed:@"upcoming_bg1@2x.png"]];
        [[cell contentView] addSubview:bkgrd];
        [bkgrd release];
        UIImageView *show = [[UIImageView alloc] initWithFrame:CGRectMake(0.08 * _viewWidth, 0, 0.46 * _viewWidth, _cellHeight)];
        [[cell contentView] addSubview:show];
        [cell setProductShow:show];
        [show release];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0.55 * _viewWidth, 0.1 * _cellHeight, 0.4 * _viewWidth, 0.3 * _cellHeight)];
        [[cell contentView] addSubview:name];
        [cell setProductName:name];
        [name release];
        [name setNumberOfLines:2];
        [name setFont:[UIFont systemFontOfSize:11]];
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0.55 * _viewWidth, 0.4 * _cellHeight, 0.5 * _viewWidth, 0.3 * _cellHeight)];
        [[cell contentView] addSubview:price];
        [cell setPrice:price];
        [price release];
        [price setTextColor:[UIColor redColor]];
        [price setFont:[UIFont systemFontOfSize:11]];
        UIButton *subscribe = [[UIButton alloc] initWithFrame:CGRectMake(0.85 * _viewWidth, 0.755 * _cellHeight, 0.15 * _viewWidth, 0.25 * _cellHeight)];
        [subscribe setBackgroundImage:[UIImage imageNamed:@"subscribe_1@2x.png"] forState:UIControlStateNormal];
        [[cell contentView] addSubview:subscribe];
        [subscribe release];
        [cell setSubscribe:subscribe];
        [subscribe addTarget:self action:@selector(subscribe:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    NSInteger buttonTag = (section<<(8 * INTEGERSIZE / 2)) | row;
    [[cell subscribe] setTag:buttonTag];
    NSArray *info = [_dataSource[section] objectForKey:@"events"];
    NSString *englishName = [info[row] objectForKey:@"englishName"];
    NSString *chineseName = [info[row] objectForKey:@"chineseName"];
    NSString *imgUrl = [info[row] objectForKey:@"imgUrl"];
    NSString *discount = [info[row] objectForKey:@"discount"];
    [[cell productName] setText:[NSString stringWithFormat:@"%@ %@", englishName, chineseName]];
    [[cell price] setText:discount];
    [[cell productShow] setImage:nil];
    [_netWorker loadDataFromURLWithString:imgUrl didFinishLoad:^(NSData *data) {
        [[cell productShow] setImage:[UIImage imageWithData:data]];
    }];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)subscribe:(UIButton *)button
{
    NSInteger section = ([button tag]>>(8 * INTEGERSIZE / 2)) & MASKLOW;
    NSInteger row = [button tag] & MASKLOW;
    NSString *message = [NSString stringWithFormat:@"您即将订阅该活动\n%@", [[_dataSource[section] objectForKey:@"events"][row] objectForKey:@"englishName"]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isUserDragging = YES;
}

@end


@implementation UpComingListCell

@end
