//
//  SpecialSiloList.m
//  MEI
//
//  Created by Yosemite on 3/11/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "SpecialSiloList.h"
#import "CategoryItemsList.h"
#import "HeaderFooterManager.h"

@interface SpecialSiloList ()
{
    CGFloat _headerHeight;
}
@end

@implementation SpecialSiloList//老佛爷奥莱

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _headerHeight = (0.220689 - 0.02) * [[UIScreen mainScreen] bounds].size.height;
    [HeaderFooterManager setWindowHeaderViewForViewController:self withHeaderStyle:headerWithBackAndShoppingBasket withTitle:_specialSiloTitle];
    CategoryItemsList *specialSiloList = [[CategoryItemsList alloc] initWithStyle:UITableViewStyleGrouped];
    specialSiloList->_categoryId = 17835;
    [self addChildViewController:specialSiloList];
    [[specialSiloList tableView] setFrame:CGRectMake(0, _headerHeight * 0.61, [[self view] bounds].size.width, [[self view] bounds].size.height - _headerHeight * 0.61)];
    [[self view] addSubview:[specialSiloList tableView]];
    [specialSiloList release];
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
