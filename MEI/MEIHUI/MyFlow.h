//
//  MyFlow.h
//  MEI
//
//  Created by Yosemite on 3/8/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyFlowDelegate;
@interface MyFlow : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, assign) id<MyFlowDelegate> myFlowDelegate;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat cellYCoordinateOffset;
@property (nonatomic, retain) NSMutableArray *dataSource;
- (void)reloadData;
- (void)dataPreparedForMoreCells:(NSInteger)cellsNumber;
@end

@class FlowCell;
@protocol MyFlowDelegate <NSObject>
@optional
- (void)myFlow:(MyFlow *)myFlow willDisplayCellAtIndex:(NSInteger)index;
- (void)myFlow:(MyFlow *)myFlow didEndDisplayCellAtIndex:(NSInteger)index;
- (void)myFlow:(MyFlow *)myFlow didSelectedCellAtIndex:(NSInteger)index;
@required
- (FlowCell *)myFlow:(MyFlow *)myFlow configureCell:(FlowCell *)cell ForIndex:(NSInteger)index;
@end

@interface FlowCell : UIView
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) UIImageView *imageShow;
@property (nonatomic, retain) UILabel *productName;
@property (nonatomic, retain) UILabel *brandName;
@property (nonatomic, retain) UILabel *marketPrice;
@property (nonatomic, retain) UILabel *price;
@property (nonatomic, retain) UIButton *button;
@end