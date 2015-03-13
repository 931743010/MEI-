//
//  Inquiry.m
//  MEI
//
//  Created by Yosemite on 3/11/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "Inquiry.h"
#import "SignIn.h"
#import "HeaderFooterManager.h"
@interface Inquiry ()
{
    BOOL _userAlreadyLoad;
}
@end

@implementation Inquiry

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [HeaderFooterManager setWindowHeaderViewForViewController:self withHeaderStyle:headerWithNavigationAndShoppingBasket withTitle:@"物流查询"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
