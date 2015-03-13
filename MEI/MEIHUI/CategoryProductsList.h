//
//  CategoryProductsList.h
//  MEI
//
//  Created by Yosemite on 3/8/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//
/***************不再使用******************/
#import <UIKit/UIKit.h>

@interface CategoryProductsList : UICollectionViewController
{
@public
    NSInteger _categoryId;
}
@end

@interface ProductListCell : UICollectionViewCell
@property (nonatomic, retain) UIImageView *imageShow;
@property (nonatomic, retain) UILabel *productName;
@property (nonatomic, retain) UILabel *brandName;
@property (nonatomic, retain) UILabel *marketPrice;
@property (nonatomic, retain) UILabel *price;
@end

/****************************************/