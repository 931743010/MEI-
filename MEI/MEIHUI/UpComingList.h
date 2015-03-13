//
//  UpComingList.h
//  MEI
//
//  Created by Yosemite on 3/10/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpComingList : UITableViewController <UIScrollViewDelegate>
@property (nonatomic, retain) UIView *navigationBarView;
@end


@interface UpComingListCell : UITableViewCell
@property (nonatomic, retain) UIImageView *productShow;
@property (nonatomic, retain) UILabel *productName;
@property (nonatomic, retain) UILabel *price;
@property (nonatomic, retain) UIButton *subscribe;
@end
