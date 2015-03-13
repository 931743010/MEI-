//
//  CategoryItemsList.h
//  MEI
//
//  Created by Yosemite on 3/5/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryItemsList : UITableViewController <UIScrollViewDelegate>
{
@public
    NSInteger _categoryId;
}
@property (nonatomic, retain) NSArray *navigationButtons;
@end

@interface ItemsListCell : UITableViewCell
@property (nonatomic, retain) UIImageView *customImageView;
@property (nonatomic, retain) UILabel *customTitleLabel;
@property (nonatomic, retain) UILabel *customNameLabel;
@property (nonatomic, retain) UILabel *customDetailLabel;
@property (nonatomic, retain) UIView *customAnimationView;
@property CGRect frameHidden;
@property CGRect frameShow;
@end

/************不再使用************/
@class CellView;
@interface ProductsListCell : UITableViewCell
@property (nonatomic, retain) CellView *leftView;
@property (nonatomic, retain) CellView *rightView;
@end

@interface CellView : UIView
@property (nonatomic, retain) UIImageView *imageShow;
@property (nonatomic, retain) UILabel *productName;
@property (nonatomic, retain) UILabel *brandName;
@property (nonatomic, retain) UILabel *marketPrice;
@property (nonatomic, retain) UILabel *price;
@end
/*******************************/