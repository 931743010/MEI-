//
//  ProductInfo.h
//  MEI
//
//  Created by Yosemite on 3/10/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductInfo : UIViewController <UIScrollViewDelegate>
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *productId;
@end
