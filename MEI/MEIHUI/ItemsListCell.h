//
//  ItemsListCell.h
//  MEI
//
//  Created by Yosemite on 3/6/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsListCell : UITableViewCell
@property (nonatomic, retain) UIImageView *customImageView;
@property (nonatomic, retain) UILabel *customTitleLabel;
@property (nonatomic, retain) UILabel *customNameLabel;
@property (nonatomic, retain) UILabel *customDetailLabel;
@property (nonatomic, retain) UIView *customAnimationView;
@property CGRect frameHidden;
@property CGRect frameShow;
@end

@interface ProductsListCell : UITableViewCell
//@property
@end