//
//  BrandsList.m
//  MEI
//
//  Created by Yosemite on 3/10/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "BrandsList.h"
#import "Network_RemoteDataLoad.h"
#import "HeaderFooterManager.h"
#import "CategoryProductsFlow.h"

@interface BrandsList ()
{
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    NSMutableArray *_dataSource;
    Network_RemoteDataLoad *_netWorker;
    NSMutableArray *_sectionFlag;
}
@end

@implementation BrandsList

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
    _netWorker = [Network_RemoteDataLoad new];
    _sectionFlag = [[NSMutableArray alloc] initWithCapacity:0];
    [[self tableView] setBackgroundColor:[UIColor whiteColor]];
    [[self tableView] setTableFooterView:[HeaderFooterManager getFooterView]];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setSectionHeaderHeight:50];
    [[self tableView] setSectionFooterHeight:0];
    [[self tableView] setRowHeight:45];
    [self loadData];
}

- (void)dealloc
{
    [_dataSource release];
    [_sectionFlag release];
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
    [_netWorker loadDataIgnoringL1CacheFromURLWithString:@"http://www.mei.com/appapi/catalog/list?pageIndex=1&summary=438c356e9e5da294402f6c4300526180" didFinishLoad:^(NSData *data) {
        NSDictionary *jdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *arr = [jdic objectForKey:@"silos"];
        if (arr)
        {
            [_dataSource addObjectsFromArray:arr];
            [self dataPrepared];
        }
    }];
}

- (void)dataPrepared
{
    for (int i = 0; i < [_dataSource count]; i++)
    {
        [_sectionFlag addObject:[NSNumber numberWithBool:NO]];
    }
    [[self tableView] reloadData];
}

- (void)sectionHeaderButtonSelected:(UIButton *)button
{
    NSInteger section = [button tag];
    if ([_sectionFlag[section] boolValue])
    {
        [_sectionFlag replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:NO]];
    }
    else
    {
        [_sectionFlag replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:YES]];
    }
    [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view data delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [[self tableView] sectionHeaderHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [[self tableView] sectionFooterHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self tableView] rowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CategoryProductsFlow *productFlow = [CategoryProductsFlow new];
    productFlow->_categoryId = 180001;
    NSArray *arr = [_dataSource[[indexPath section]] objectForKey:@"lists"];
    [productFlow setTitle:[arr[[indexPath row]] objectForKey:@"englishName"]];
    [[self navigationController] pushViewController:productFlow animated:YES];
    [productFlow release];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, [tableView sectionHeaderHeight])] autorelease];
    [sectionHeader setBackgroundColor:[UIColor whiteColor]];
    UIImageView *separationLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.05 * _viewWidth, [sectionHeader bounds].size.height - 1, 0.9 * _viewWidth, 0.5)];
    [separationLine setImage:[UIImage imageNamed:@"line_1@2x.png"]];
    [sectionHeader addSubview:separationLine];
    [separationLine release];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0.05 * _viewWidth, 0.25 * [tableView sectionHeaderHeight], 0.5 * [tableView sectionHeaderHeight], 0.5 * [tableView sectionHeaderHeight])];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0.2 * _viewWidth, 0, 0.6 * _viewWidth, [[self tableView] sectionHeaderHeight])];
    UIImageView *indicator = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth - [tableView sectionHeaderHeight], 0.25 * [tableView sectionHeaderHeight], 0.5 * [tableView sectionHeaderHeight], 0.5 * [tableView sectionHeaderHeight])];
    [sectionHeader addSubview:icon];
    [sectionHeader addSubview:title];
    [sectionHeader addSubview:indicator];
    [icon release];
    [title release];
    [indicator release];
    [icon setTag:0x710];
    [title setTag:0x800];
    [indicator setTag:0x720];
    [title setFont:[UIFont systemFontOfSize:14]];
    [indicator setImage:[UIImage imageNamed:@"btn_close_normal@2x.png"]];
    if (section == 0)
    {
        [title setText:@"女士"];
    }
    else if (section == 1)
    {
        [title setText:@"男士"];
    }
    else if (section == 2)
    {
        [title setText:@"美妆"];
    }
    else if (section == 3)
    {
        [title setText:@"家居"];
    }
    else if (section == 4)
    {
        [title setText:@"婴童"];
    }
    else if (section == 5)
    {
        [title setText:@"老佛爷奥莱"];
    }
    if (![_sectionFlag[section] boolValue])
    {
        [indicator setImage:[UIImage imageNamed:@"btn_close_normal@2x.png"]];
        if (section == 0)
        {
            [icon setImage:[UIImage imageNamed:@"brand_events_icon_1@2x.png"]];
        }
        else if (section == 1)
        {
            [icon setImage:[UIImage imageNamed:@"brand_events_icon_2.png"]];
        }
        else if (section == 2)
        {
            [icon setImage:[UIImage imageNamed:@"brand_events_icon_4.png"]];
        }
        else if (section == 3)
        {
            [icon setImage:[UIImage imageNamed:@"brand_events_icon_5.png"]];
        }
        else if (section == 4)
        {
            [icon setImage:[UIImage imageNamed:@"brand_events_icon_3.png"]];
        }
        else if (section == 5)
        {
            [icon setImage:[UIImage imageNamed:@"brand_events_icon_6@2x.png"]];
        }
    }
    else
    {
        [indicator setImage:[UIImage imageNamed:@"btn_close_selected@2x.png"]];
        if (section == 0)
        {
            [icon setImage:[UIImage imageNamed:@"brand_events_icon_1_on@2x.png"]];
        }
        else if (section == 1)
        {
            [icon setImage:[UIImage imageNamed:@"brand_events_icon_2_on@2x.png"]];
        }
        else if (section == 2)
        {
            [icon setImage:[UIImage imageNamed:@"brand_events_icon_4_on@2x.png"]];
        }
        else if (section == 3)
        {
            [icon setImage:[UIImage imageNamed:@"brand_events_icon_5_on@2x.png"]];
        }
        else if (section == 4)
        {
            [icon setImage:[UIImage imageNamed:@"brand_events_icon_3_on@2x.png"]];
        }
        else if (section == 5)
        {
            [icon setImage:[UIImage imageNamed:@"brand_events_icon_6_on@2x.png"]];
        }
    }
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [indicator setContentMode:UIViewContentModeScaleAspectFit];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, [[self tableView] sectionHeaderHeight])];
    [sectionHeader addSubview:button];
    [button setTag:section];
    [button release];
    [button addTarget:self action:@selector(sectionHeaderButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    return sectionHeader;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([_sectionFlag[section] boolValue])
    {
        return [[_dataSource[section] objectForKey:@"lists"] count];
    }
    else
    {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // Configure the cell...
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        [[cell contentView] setBackgroundColor:[UIColor whiteColor]];
        UIImageView *separationLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.05 * _viewWidth, [tableView rowHeight] - 2, 0.9 * _viewWidth, 1.5)];
        [separationLine setImage:[UIImage imageNamed:@"line_2@2x.png"]];
        [[cell contentView] addSubview:separationLine];
        [separationLine release];
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.09 * _viewWidth, 0, 0.63 * _viewWidth, [tableView rowHeight])];
        UILabel *right = [[UILabel alloc] initWithFrame:CGRectMake(0.75 * _viewWidth, 0, 0.16 * _viewWidth, [tableView rowHeight])];
        [[cell contentView] addSubview:leftLabel];
        [[cell contentView] addSubview:right];
        [leftLabel release];
        [right release];
        [leftLabel setTag:0x810];
        [right setTag:0x820];
        [leftLabel setNumberOfLines:2];
        [right setTextColor:[UIColor redColor]];
        [leftLabel setFont:[UIFont systemFontOfSize:13]];
        [right setFont:[UIFont systemFontOfSize:13]];
        [right setTextAlignment:NSTextAlignmentRight];
    }
    UILabel *name = (UILabel *)[[cell contentView] viewWithTag:0x810];
    UILabel *price = (UILabel *)[[cell contentView] viewWithTag:0x820];
    NSArray *infos = [_dataSource[[indexPath section]] objectForKey:@"lists"];
    [name setText:[NSString stringWithFormat:@"%@ %@", [infos[[indexPath row]] objectForKey:@"englishName"], [infos[[indexPath row]] objectForKey:@"chineseName"]]];
    [price setText:[infos[[indexPath row]] objectForKey:@"discount"]];
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

@end
