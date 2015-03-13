//
//  UpComing.m
//  MEI
//
//  Created by Yosemite on 3/10/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "UpComing.h"
#import "UpComingList.h"
#import "HeaderFooterManager.h"

@interface UpComing ()
{
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    CGFloat _headerHeight;
    
}
@end

@implementation UpComing

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _headerHeight = (0.220689 - 0.02) * [[UIScreen mainScreen] bounds].size.height;
    _viewWidth = [[self view] bounds].size.width;
    _viewHeight = [[self view] bounds].size.height;
    [HeaderFooterManager setWindowHeaderViewForViewController:self withHeaderStyle:headerWithNavigationAndShoppingBasket withTitle:@"即将上线"];
    UIView *view = [[self navigationViewInHeader] retain];
    [[self view] addSubview:view];
    [view release];
    UpComingList *upcomingList = [[UpComingList alloc] initWithStyle:UITableViewStyleGrouped];
    [upcomingList setNavigationBarView:view];
    [[upcomingList tableView] setFrame:CGRectMake(0, _headerHeight, _viewWidth, _viewHeight - _headerHeight)];
    [self addChildViewController:upcomingList];
    [[self view] addSubview:[upcomingList tableView]];
    [upcomingList release];
    
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#define BUTTONHEIGHT 3.9

- (UIView *)navigationViewInHeader
{
    UIView *backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, _headerHeight * (10 - BUTTONHEIGHT) / 10, _viewWidth, _headerHeight * BUTTONHEIGHT / 10)] autorelease];
    [backgroundView setBackgroundColor:[UIColor blackColor]];
    return backgroundView;
}

@end
