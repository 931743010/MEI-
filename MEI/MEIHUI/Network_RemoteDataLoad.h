//
//  Network_RemoteDataLoad.h
//  NETWORK
//
//  Created by Yosemite on 2/4/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Network_RemoteDataLoad : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
- (NSString *)isDataLoadedFromURLWithString:(NSString *)URLStr;
- (void)loadDataFromURLWithString:(NSString *)URLString didFinishLoad:(void (^)(NSData *data))didFinishLoad;
- (void)loadDataIgnoringL1CacheFromURLWithString:(NSString *)URLString didFinishLoad:(void (^)(NSData *data))didFinishLoad;
- (BOOL)emptyAllCaches;
- (BOOL)cancelConnectionOfURLWithString:(NSString *)URLStr;
//- (NSString *)formatURL:(NSString *)sourceURLStr;
@end

@interface NSURLConnection (NetWork_1764)
@property (atomic, assign) NSInteger tag;
@property (atomic, assign) NSInteger index;
@end