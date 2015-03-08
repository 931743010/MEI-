//
//  URLCreate.m
//  MEI
//
//  Created by Yosemite on 3/5/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "URLCreate.h"
#import "URL.h"

@implementation URLCreate
+ (NSString *)getURLWithCategoryId:(NSInteger)categoryId pageIndex:(NSInteger)pageIndex
{
    NSString *summary = nil;
    NSString *urlString = nil;
    if (categoryId == -1)
    {
        switch (pageIndex)
        {
            case 1:
                summary = S_PAGEINDEX1;
                break;
            case 2:
                summary = S_PAGEINDEX2;
                break;
            case 3:
                summary = S_PAGEINDEX3;
                break;
            case 4:
                summary = S_PAGEINDEX4;
                break;
            case 5:
                summary = S_PAGEINDEX5;
                break;
            case 6:
                summary = S_PAGEINDEX6;
                break;
            case 7:
                summary = S_PAGEINDEX7;
                break;
            case 8:
                summary = S_PAGEINDEX8;
                break;
            case 9:
                summary = S_PAGEINDEX9;
                break;
            case 10:
                summary = S_PAGEINDEX10;
                break;
            case 11:
                summary = S_PAGEINDEX11;
                break;
            default:
                break;
        }
        urlString = [NSString stringWithFormat:@"http://www.mei.com/appapi/home/event?categoryId=&pageIndex=%ld&summary=%@", (long)pageIndex, summary];
    }
    else
    {
        switch (categoryId)
        {
            case SILO_CATID_NVSHI:
                switch (pageIndex)
                {
                    case 1:
                        summary = S_CATE12718_PGID1;
                        break;
                    case 2:
                        summary = S_CATE12718_PGID2;
                        break;
                    case 3:
                        summary = S_CATE12718_PGID3;
                        break;
                    case 4:
                        summary = S_CATE12718_PGID4;
                        break;
                    case 5:
                        summary = S_CATE12718_PGID5;
                        break;
                    default:
                        break;
                }
                break;
            case SILO_CATID_NANSHI:
                switch (pageIndex)
                {
                    case 1:
                        summary = S_CATE12719_PGID1;
                        break;
                    case 2:
                        summary = S_CATE12719_PGID2;
                        break;
                    default:
                        break;
                }
                break;
            case SILO_CATID_MEIZHUANG:
                switch (pageIndex)
                {
                    case 1:
                        summary = S_CATE12720_PGID1;
                        break;
                    case 2:
                        summary = S_CATE12720_PGID2;
                        break;
                    case 3:
                        summary = S_CATE12720_PGID3;
                        break;
                    case 4:
                        summary = S_CATE12720_PGID4;
                        break;
                    default:
                        break;
                }
                break;
            case SILO_CATID_JIAJU:
                switch (pageIndex)
                {
                    case 1:
                        summary = S_CATE12721_PGID1;
                        break;
                    default:
                        break;
                }
                break;
            case SILO_CATID_YINGTONG:
                switch (pageIndex)
                {
                    case 1:
                        summary = S_CATE12722_PGID1;
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
        urlString = [NSString stringWithFormat:@"http://www.mei.com/appapi/silo/event?categoryId=%ld&pageIndex=%ld&summary=%@", (long)categoryId, (long)pageIndex, summary];
    }
    return urlString;
}

+ (NSString *)randomURL
{
    NSString *urlStr = nil;
    
    return urlStr;
}
@end
