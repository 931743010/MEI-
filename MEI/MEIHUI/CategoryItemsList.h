//
//  CategoryItemsList.h
//  MEI
//
//  Created by Yosemite on 3/5/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableFooterView.h"

@interface CategoryItemsList : UITableViewController <UIScrollViewDelegate, TableFooterViewDelegate>
{
@public
    NSInteger _categoryId;
}
@end
