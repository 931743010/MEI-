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
    if (categoryId > 17840)
    {
        return [self randomURL];
    }
    if (categoryId == 17835)//
    {
        return @"http://www.mei.com/appapi/silo/specialSiloTemplate?categoryId=17835&summary=3df0358b46d986f2d7a9c5532b9e2e0b";
    }
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
            case 12:
                summary = S_PAGEINDEX12;
                break;
            case 13:
                summary = S_PAGEINDEX13;
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
                    case 3:
                        summary = S_CATE12719_PGID3;
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
    //已过期活动
//    NSString *urlStr = @"http://www.mei.com/appapi/event/product?categoryId=18775&pageIndex=1&sort=&summary=0a095c262ecc93a272e535d522a12bfd";
//    NSInteger randRst = random()%6;
//    switch (randRst)
//    {
//        case 0:
//            urlStr = @"http://www.mei.com/appapi/event/product?categoryId=18775&pageIndex=1&sort=&summary=0a095c262ecc93a272e535d522a12bfd";
//            break;
//        case 1:
//            urlStr = @"http://www.mei.com/appapi/event/product?categoryId=18775&pageIndex=1&sort=&summary=0a095c262ecc93a272e535d522a12bfd";
//            break;
//        case 2:
//            urlStr = @"http://www.mei.com/appapi/event/product?categoryId=18981&pageIndex=1&sort=&summary=03b773b43eddeb8dfb662550a31eeaca";
//            break;
//        case 3:
//            urlStr = @"http://www.mei.com/appapi/event/product?categoryId=18969&pageIndex=1&sort=&summary=e39c7f03f0e1dd2f7d39198c4e3c4f1f";
//            break;
//        case 4:
//            urlStr = @"http://www.mei.com/appapi/event/product?categoryId=18758&pageIndex=1&sort=&summary=acf16b344bcb52a33eff331ff19e2467";
//            break;
//        case 5:
//            urlStr = @"http://www.mei.com/appapi/event/product?categoryId=18905&pageIndex=1&sort=&summary=82998d458384146c60407a7d9aad88c4";
//            break;
//        default:
//            break;
//    }
    
    
    NSString *urlStr = @"http://www.mei.com/appapi/event/product?categoryId=18746&pageIndex=1&sort=&summary=8eddd1b86cab8a5e51a2225120d0a0d1";
    //NSString *urlStr2 = @"http://www.mei.com/appapi/event/product?categoryId=18845&pageIndex=1&sort=&summary=0f6e1665bcb3efd492beaf77f12df3d2";
    
    return urlStr;
}
@end
