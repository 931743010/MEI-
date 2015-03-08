//
//  TableFooterView.h
//  MEI
//
//  Created by Yosemite on 3/7/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableFooterViewDelegate;

@interface TableFooterView : UIView
@property (nonatomic, assign) id<TableFooterViewDelegate> delegate;

@end

@protocol TableFooterViewDelegate <NSObject>
- (void)buttonDidTouchUpInside:(UIButton *)button;

@end