//
//  MyInformation.m
//  MEI
//
//  Created by Yosemite on 3/11/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "MyInformation.h"
#import "HeaderFooterManager.h"
#import "SignIn.h"

@interface MyInformation ()
{
    BOOL _userAlreadyLoad;
}
@end

@implementation MyInformation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [HeaderFooterManager setWindowHeaderViewForViewController:self withHeaderStyle:headerWithNavigationAndShoppingBasket withTitle:@"我的魅力惠"];
    _userAlreadyLoad = NO;
    if (_userAlreadyLoad)
    {
        
    }
    else
    {
        SignIn *signIn = [SignIn new];
        [[self navigationController] pushViewController:signIn animated:YES];
        [signIn release];
    }
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
