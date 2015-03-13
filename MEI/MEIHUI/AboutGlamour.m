//
//  AboutGlamour.m
//  MEI
//
//  Created by Yosemite on 3/9/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "AboutGlamour.h"
#import "HeaderFooterManager.h"

@interface AboutGlamour ()
{
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    CGFloat _headerHeight;
}
@end

@implementation AboutGlamour

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _headerHeight = (0.220689 - 0.02) * [[UIScreen mainScreen] bounds].size.height;
    _viewWidth = [[self view] bounds].size.width;
    _viewHeight = [[self view] bounds].size.height;
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [HeaderFooterManager setWindowHeaderViewForViewController:self withHeaderStyle:headerWithNavigationAndShoppingBasket withTitle:@"关于魅力惠"];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0.61 * (0.220689 - 0.02) * _viewHeight, _viewWidth, (1 - 0.61 * (0.220689 - 0.02)) * _viewHeight)];
    [[self view] addSubview:scrollView];
    [scrollView release];
    /*640 x 3280*/
    [scrollView setContentSize:CGSizeMake(_viewWidth, _viewWidth * 3280 / 640 + 150)];
    UIImageView *aboutGlamourImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewWidth * 3280 / 640)];
    [aboutGlamourImageView setImage:[UIImage imageNamed:@"ios_about_Glamour_bg@2x.png"]];
    [scrollView addSubview:aboutGlamourImageView];
    [aboutGlamourImageView release];
    UIView *footer = [[HeaderFooterManager getFooterView] retain];
    [footer setFrame:CGRectMake(0, _viewWidth * 3280 / 640, _viewWidth, 150)];
    [scrollView addSubview:footer];
    [footer release];
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
