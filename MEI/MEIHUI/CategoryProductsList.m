//
//  CategoryProductsList.m
//  MEI
//
//  Created by Yosemite on 3/8/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "CategoryProductsList.h"

@interface CategoryProductsList ()
{
    UIWebView *_productShow;
}
@end

@implementation CategoryProductsList

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:[URLCreate randomURL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _productShow = [[UIWebView alloc] initWithFrame:[[self view] bounds]];
    [[self view] addSubview:_productShow];
    [_productShow loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_productShow release];
    [super dealloc];
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
