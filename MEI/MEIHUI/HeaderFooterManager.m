//
//  HeaderFooterManager.m
//  MEI
//
//  Created by Yosemite on 3/10/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "HeaderFooterManager.h"
#import "SignIn.h"
#import "TableFooterView.h"

#define BUTTONHEIGHT 3.9//"3.9/10", navigation buttons in home page

@implementation HeaderFooterManager
#pragma mark - header
+ (void)setWindowHeaderViewForViewController:(UIViewController *)viewController withHeaderStyle:(headerStyle)style withTitle:(NSString *)title
{
    if (style == headerWithNavigationAndShoppingBasket)
    {
        [self headerWithNavigationAndShoppingBasketForViewController:viewController withTitle:title];
    }
    else if (style == headerWithBackAndShoppingBasket)
    {
        [self headerWithBackButtonAndShoppingBasketForViewController:viewController withTitle:title];
    }
    else if (style == headerWithBackOnly)
    {
        [self headerWithBackButtonOnlyForViewController:viewController withTitle:title];
    }
}

+ (void)headerWithNavigationAndShoppingBasketForViewController:(UIViewController *)viewController withTitle:(NSString *)title
{
    CGFloat _headerHeight = _headerHeight = (0.220689 - 0.02) * [[UIScreen mainScreen] bounds].size.height;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _headerHeight * (10 - BUTTONHEIGHT) / 10)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    [[viewController view] addSubview:headerView];
    [headerView release];
    
    UIImageView *separationLine = [[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width *0.9 / 6, 0.25 * [headerView bounds].size.height + 5, 2, 0.75 * [headerView bounds].size.height - 10)];
    [separationLine setImage:[UIImage imageNamed:@"top_Line@2x.png"]];
    [headerView addSubview:separationLine];
    [separationLine release];
    [separationLine setContentMode:UIViewContentModeCenter];
    [separationLine setClipsToBounds:YES];
    
    UIButton *navigationButton = [[UIButton alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width * 0.9 / 6 - 0.5 * [headerView bounds].size.height) / 2, 0.375 * [headerView bounds].size.height, 0.5 * [headerView bounds].size.height, 0.5 * [headerView bounds].size.height)];
    [navigationButton setBackgroundImage:[UIImage imageNamed:@"more@2x.png"] forState:UIControlStateNormal];
    [headerView addSubview:navigationButton];
    [navigationButton release];
    [navigationButton setContentMode:UIViewContentModeScaleAspectFit];
    [navigationButton addTarget:self action:@selector(navigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [navigationButton setTag:(NSInteger)viewController];
    
    UIButton *shoppingBasket = [[UIButton alloc] initWithFrame:CGRectMake([headerView bounds].size.width - [navigationButton bounds].size.width - [navigationButton frame].origin.x, [navigationButton frame].origin.y, 0.8 * [navigationButton bounds].size.width, 0.8 * [navigationButton bounds].size.height)];
    [shoppingBasket setBackgroundImage:[UIImage imageNamed:@"top_shopping_bag@2x.png"] forState:UIControlStateNormal];
    [headerView addSubview:shoppingBasket];
    [shoppingBasket release];
    [shoppingBasket addTarget:self action:@selector(goToShoppingBasketButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [shoppingBasket setTag:(NSInteger)viewController];
    
    if (title)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([separationLine frame].origin.x + 2, [separationLine frame].origin.y, [[UIScreen mainScreen] bounds].size.width - 2 * [separationLine frame].origin.x - 4, [separationLine bounds].size.height)];
        [headerView addSubview:titleLabel];
        [titleLabel release];
        [titleLabel setText:title];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    else
    {
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width * 0.9 / 6 + ([[UIScreen mainScreen] bounds].size.width *0.9 / 6 - 0.25 * [headerView bounds].size.height) / 2, 0.5 * [headerView bounds].size.height, 0.25 * [headerView bounds].size.height * 369 / 43, 0.25 * [headerView bounds].size.height)];
        [logoView setImage:[UIImage imageNamed:@"logo_wechat@2x.png"]];
        [headerView addSubview:logoView];
        [logoView release];
    }
    
    UIImageView *separationLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, [headerView bounds].size.height - 0.5, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    [separationLine2 setImage:[UIImage imageNamed:@"line_ord@2x.png"]];
    [headerView addSubview:separationLine2];
    [separationLine2 release];
    
    [headerView setTag:0x5000];
}

+ (void)headerWithBackButtonAndShoppingBasketForViewController:(UIViewController *)viewController withTitle:(NSString *)title
{
    CGFloat _headerHeight = _headerHeight = (0.220689 - 0.02) * [[UIScreen mainScreen] bounds].size.height;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _headerHeight * (10 - BUTTONHEIGHT) / 10)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    [[viewController view] addSubview:headerView];
    [headerView release];
    
    UIImageView *separationLine = [[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width *0.9 / 6, 0.25 * [headerView bounds].size.height + 5, 2, 0.75 * [headerView bounds].size.height - 10)];
    [separationLine setImage:[UIImage imageNamed:@"top_Line@2x.png"]];
    [headerView addSubview:separationLine];
    [separationLine release];
    [separationLine setContentMode:UIViewContentModeCenter];
    [separationLine setClipsToBounds:YES];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width * 0.9 / 6 - 0.5 * [headerView bounds].size.height) / 2, 0.375 * [headerView bounds].size.height, 0.5 * [headerView bounds].size.height, 0.5 * [headerView bounds].size.height)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    [headerView addSubview:backButton];
    [backButton release];
    [backButton setContentMode:UIViewContentModeScaleAspectFit];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTag:(NSInteger)viewController];
    
    UIButton *shoppingBasket = [[UIButton alloc] initWithFrame:CGRectMake([headerView bounds].size.width - [backButton bounds].size.width - [backButton frame].origin.x, [backButton frame].origin.y, 0.8 * [backButton bounds].size.width, 0.8 * [backButton bounds].size.height)];
    [shoppingBasket setBackgroundImage:[UIImage imageNamed:@"top_shopping_bag@2x.png"] forState:UIControlStateNormal];
    [headerView addSubview:shoppingBasket];
    [shoppingBasket release];
    [shoppingBasket addTarget:self action:@selector(goToShoppingBasketButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [shoppingBasket setTag:(NSInteger)viewController];
    
    if (title)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([separationLine frame].origin.x + 2, [separationLine frame].origin.y, [[UIScreen mainScreen] bounds].size.width - 2 * [separationLine frame].origin.x - 4, [separationLine bounds].size.height)];
        [headerView addSubview:titleLabel];
        [titleLabel release];
        [titleLabel setText:title];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    else
    {
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width * 0.9 / 6 + ([[UIScreen mainScreen] bounds].size.width *0.9 / 6 - 0.25 * [headerView bounds].size.height) / 2, 0.5 * [headerView bounds].size.height, 0.25 * [headerView bounds].size.height * 369 / 43, 0.25 * [headerView bounds].size.height)];
        [logoView setImage:[UIImage imageNamed:@"logo_wechat@2x.png"]];
        [headerView addSubview:logoView];
        [logoView release];
    }
    
    UIImageView *separationLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, [headerView bounds].size.height - 0.5, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    [separationLine2 setImage:[UIImage imageNamed:@"line_ord@2x.png"]];
    [headerView addSubview:separationLine2];
    [separationLine2 release];
    
    [headerView setTag:0x5000];
}

+ (void)headerWithBackButtonOnlyForViewController:(UIViewController *)viewController withTitle:(NSString *)title
{
    CGFloat _headerHeight = _headerHeight = (0.220689 - 0.02) * [[UIScreen mainScreen] bounds].size.height;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _headerHeight * (10 - BUTTONHEIGHT) / 10)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    [[viewController view] addSubview:headerView];
    [headerView release];
    
    UIImageView *separationLine = [[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width *0.9 / 6, 0.25 * [headerView bounds].size.height + 5, 2, 0.75 * [headerView bounds].size.height - 10)];
    [separationLine setImage:[UIImage imageNamed:@"top_Line@2x.png"]];
    [headerView addSubview:separationLine];
    [separationLine release];
    [separationLine setContentMode:UIViewContentModeCenter];
    [separationLine setClipsToBounds:YES];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width * 0.9 / 6 - 0.5 * [headerView bounds].size.height) / 2, 0.375 * [headerView bounds].size.height, 0.5 * [headerView bounds].size.height, 0.5 * [headerView bounds].size.height)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    [headerView addSubview:backButton];
    [backButton release];
    [backButton setContentMode:UIViewContentModeScaleAspectFit];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTag:(NSInteger)viewController];
    
    if (title)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([separationLine frame].origin.x + 2, [separationLine frame].origin.y, [[UIScreen mainScreen] bounds].size.width - 2 * [separationLine frame].origin.x - 4, [separationLine bounds].size.height)];
        [headerView addSubview:titleLabel];
        [titleLabel release];
        [titleLabel setText:title];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    else
    {
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width * 0.9 / 6 + ([[UIScreen mainScreen] bounds].size.width *0.9 / 6 - 0.25 * [headerView bounds].size.height) / 2, 0.5 * [headerView bounds].size.height, 0.25 * [headerView bounds].size.height * 369 / 43, 0.25 * [headerView bounds].size.height)];
        [logoView setImage:[UIImage imageNamed:@"logo_wechat@2x.png"]];
        [headerView addSubview:logoView];
        [logoView release];
    }
    
    UIImageView *separationLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, [headerView bounds].size.height - 0.5, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    [separationLine2 setImage:[UIImage imageNamed:@"line_ord@2x.png"]];
    [headerView addSubview:separationLine2];
    [separationLine2 release];
    
    [headerView setTag:0x5000];
}

+ (void)backButtonAction:(UIButton *)button
{
    UIViewController *viewController = (UIViewController *)[button tag];
    [[viewController navigationController] popViewControllerAnimated:YES];
}

+ (void)goToShoppingBasketButtonAction:(UIButton *)button
{
    UIViewController *viewController = (UIViewController *)[button tag];
    if (NO)//if already sign in
    {
        
    }
    else//go to sign in
    {
        SignIn *signIn = [SignIn new];
        [[viewController navigationController] pushViewController:signIn animated:YES];
        [signIn release];
    }
}

+ (void)navigationButtonAction:(UIButton *)button
{
    __block UIScrollView *scrollView = [(UIResponder *)[[UIApplication sharedApplication] delegate] valueForKey:@"scrollView"];
    if ([scrollView contentOffset].x == 0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [scrollView setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width, 0)];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }];
    }
}

#pragma mark - footer

+ (UIView *)getFooterView
{
    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 150)] autorelease];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    //a separation line:
    /*
    UIImageView *separationLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    [separationLine setImage:[UIImage imageNamed:@"line_ord@2x.png"]];
    [tableFooter addSubview:separationLine];
    [separationLine release];
    */
    TableFooterView *buttonView = [[TableFooterView alloc] initWithFrame:CGRectMake(20, 10, [[UIScreen mainScreen] bounds].size.width - 40, 120)];
    [footerView addSubview:buttonView];
    [buttonView release];
    [buttonView setDelegate:(id<TableFooterViewDelegate>)[[UIApplication sharedApplication] delegate]];
    return footerView;
}

@end


