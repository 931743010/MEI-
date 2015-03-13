//
//  HeaderFooterManager.h
//  MEI
//
//  Created by Yosemite on 3/10/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum headerViewStyle {
    headerWithNavigationAndShoppingBasket,
    headerWithBackAndShoppingBasket,
    headerWithBackOnly
} headerStyle;

@interface HeaderFooterManager : NSObject
+ (void)setWindowHeaderViewForViewController:(UIViewController *)viewController withHeaderStyle:(headerStyle)style withTitle:(NSString *)title;
+ (UIView *)getFooterView;
@end
