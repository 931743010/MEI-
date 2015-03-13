//
//  CategoryProductsFlow.h
//  MEI
//
//  Created by Yosemite on 3/8/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFlow.h"

@interface CategoryProductsFlow : UIViewController <MyFlowDelegate>
{
    @public
    NSInteger _categoryId;
}
@property (nonatomic, copy) NSString *title;
@end
