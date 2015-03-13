//
//  AboutApp.m
//  MEI
//
//  Created by Yosemite on 3/12/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "AboutApp.h"
#import "HeaderFooterManager.h"
@interface AboutApp ()

@end

@implementation AboutApp

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [HeaderFooterManager setWindowHeaderViewForViewController:self withHeaderStyle:headerWithBackAndShoppingBasket withTitle:@"关于"];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.25 * [[self view] bounds].size.width, 0.15 * [[self view] bounds].size.height, 0.5 * [[self view] bounds].size.width, 0.55 * [[self view] bounds].size.width / 369 * 43)];
    [[self view] addSubview:logoImage];
    [logoImage release];
    [logoImage setImage:[UIImage imageNamed:@"logo_wechat@2x.png"]];
    
    UIImageView *qrCode = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QRCode.jpg"]];
    [qrCode setFrame:CGRectMake(0.3 * [[self view] bounds].size.width, 0.25 * [[self view] bounds].size.height, 0.4 * [[self view] bounds].size.width, 0.4 * [[self view] bounds].size.width)];
    [[self view] addSubview:qrCode];
    [qrCode release];
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(0.35 * [[self view] bounds].size.width, 0.2 * [[self view] bounds].size.height, 0.3 * [[self view] bounds].size.width, 0.05 * [[self view] bounds].size.height)];
    [[self view] addSubview:version];
    [version setText:@"iPhone 2.4"];
    [version release];
    [version setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0.1 * [[self view] bounds].size.width, 0.5 * [[self view] bounds].size.height, 0.8 * [[self view] bounds].size.width, 0.05 * [[self view] bounds].size.height)];
    [message setText:@"扫描二维码，您的朋友也可以下载魅力惠客户端"];
    [[self view] addSubview:message];
    [message release];
    [message setFont:[UIFont systemFontOfSize:12]];
    [message setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.32 * [[self view] bounds].size.width, 0.58 * [[self view] bounds].size.height, 0.36 * [[self view] bounds].size.width, 0.07 * [[self view] bounds].size.height)];
    [button setBackgroundImage:[UIImage imageNamed:@"button_red_middle1.png"] forState:UIControlStateNormal];
    [[self view] addSubview:button];
    [button release];
    [button setTitle:@"分享给好友" forState:UIControlStateNormal];
    
    UILabel *copyright = [[UILabel alloc] initWithFrame:CGRectMake(0.15 * [[self view] bounds].size.width, 0.68 * [[self view] bounds].size.height, 0.7 * [[self view] bounds].size.width, 0.06 * [[self view] bounds].size.height)];
    [copyright setText:@"copyright©2014\n魅惠所贸易（上海）有限公司版权所有"];
    [copyright setNumberOfLines:2];
    [[self view] addSubview:copyright];
    [copyright release];
    [copyright setFont:[UIFont systemFontOfSize:12]];
    [copyright setTextAlignment:NSTextAlignmentCenter];
    
    UIView *footer = [[HeaderFooterManager getFooterView] retain];
    [footer setFrame:CGRectMake(0, [[self view] bounds].size.height - 150, [[self view] bounds].size.width, 150)];
    [[self view] addSubview:footer];
    [footer release];
}

- (void)didReceiveMemoryWarning {
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
