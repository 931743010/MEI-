//
//  Brand.m
//  MEI
//
//  Created by Yosemite on 3/11/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "Brand.h"
#import "BrandsList.h"
#import "HeaderFooterManager.h"

@interface Brand ()
{
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    CGFloat _headerHeight;
}
@end

@implementation Brand

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewWidth = [[self view] bounds].size.width;
    _viewHeight = [[self view] bounds].size.height;
    _headerHeight = (0.220689 - 0.02) * [[UIScreen mainScreen] bounds].size.height;
    [HeaderFooterManager setWindowHeaderViewForViewController:self withHeaderStyle:headerWithNavigationAndShoppingBasket withTitle:@"品牌活动"];
    BrandsList *brandsList = [[BrandsList alloc] initWithStyle:UITableViewStyleGrouped];
    [[brandsList tableView] setFrame:CGRectMake(0, _headerHeight * 0.61, _viewWidth, _viewHeight - _headerHeight * 0.61)];
    [self addChildViewController:brandsList];
    [[self view] addSubview:[brandsList tableView]];
    [brandsList release];
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

@end
