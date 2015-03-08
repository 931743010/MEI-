//
//  URLCreate.h
//  MEI
//
//  Created by Yosemite on 3/5/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLCreate : NSObject
+ (NSString *)getURLWithCategoryId:(NSInteger)categoryId pageIndex:(NSInteger)pageIndex;
+ (NSString *)randomURL;
@end
