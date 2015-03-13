//
//  URL.h
//  MEI
//
//  Created by Yosemite on 3/5/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#ifndef Network_Background_Cache_URL_h
#define Network_Background_Cache_URL_h
#endif

//silo categoryid的类别划分，用以获得首頁对应类别的商品列表，不同于httprequest获得的categoryId、siloCategory(silo name)。
//从catalog／list?pageIndex=1&summary=请求所有silo类信息。
#define SILO_CATID_NVSHI 12718//女士
#define SILO_CATID_NANSHI 12719//男士
#define SILO_CATID_MEIZHUANG 12720//美妆
#define SILO_CATID_JIAJU 12721//家居
#define SILO_CATID_YINGTONG 12722//婴童
//categoryId url中?categoryTd=参数，细分商品检索类别，可从商品信息获得。

//summary w!!!
#define S_NONARG @"ab37c575dd399d014187f1c8c0d921a9"

#define S_PAGEINDEX1 @"438c356e9e5da294402f6c4300526180"
#define S_PAGEINDEX2 @"751d4246ef99acf49766cd10b7d4c935"
#define S_PAGEINDEX3 @"188c70a512de14174a1bdaecda3a1a5b"
#define S_PAGEINDEX4 @"73b313ae171b261ab5f6778c04add77d"
#define S_PAGEINDEX5 @"b026c2680e4c26b4a1cda2569e4b5c1d"
#define S_PAGEINDEX6 @"0415b1e7e8799fe0ae8f49214aa88cb0"
#define S_PAGEINDEX7 @"0eeb2f0a3ff8aec88b7c4e4fb286f318"
#define S_PAGEINDEX8 @"32efd3ef78dc5f1d7997ebc403c789cf"
#define S_PAGEINDEX9 @"b305290ec04b404bb5d98e1118855f56"
#define S_PAGEINDEX10 @"4d2e921c6546df60b23b20b89a967ef9"
#define S_PAGEINDEX11 @"29ea0ab4bd37e3c39a0463d3ad8190dc"
#define S_PAGEINDEX12 @"0e0c8ec87f533ab05c36030cb1e4f49b"
#define S_PAGEINDEX13 @"d4ed8c75350232118a39f0463fd670a5"

#define S_CATE12718_PGID1 @"f27b33b08a9854fa90661f60956c6587"
#define S_CATE12718_PGID2 @"8dc896f171af9d757ec4607b913c97ea"
#define S_CATE12718_PGID3 @"0b0e8c038349aa0238f9623e6c849689"
#define S_CATE12718_PGID4 @"2846c6b3d211d4d870fb01c8c70e43fc"
#define S_CATE12718_PGID5 @"94845c71513b5284c5bf22adba51050b"
#define S_CATE12718_PGID6

#define S_CATE12719_PGID1 @"2a43e7f41e0b49c8b47ab797f4339f5c"
#define S_CATE12719_PGID2 @"62ec5cb76335926388388a1b181f069a"
#define S_CATE12719_PGID3 @"563d06bed68ace5779dfd77303fd6e07"
#define S_CATE12719_PGID4
#define S_CATE12719_PGID5
#define S_CATE12719_PGID6

#define S_CATE12720_PGID1 @"f8c79fdf3d7f1c9381f36b927fcd3f67"
#define S_CATE12720_PGID2 @"19214627de3b812f205c6260025aa797"
#define S_CATE12720_PGID3 @"ddfd36cee1499ee2b15fd32df17a17d1"
#define S_CATE12720_PGID4 @"c94c3f5df965f4112f4aa26c6f221a88"
#define S_CATE12720_PGID5
#define S_CATE12720_PGID6

#define S_CATE12721_PGID1 @"cb26eb60e4026f0f57941b7e7086e5ba"
#define S_CATE12721_PGID2
#define S_CATE12721_PGID3
#define S_CATE12721_PGID4
#define S_CATE12721_PGID5
#define S_CATE12721_PGID6

#define S_CATE12722_PGID1 @"a71f6dd29488b43b72c5b35b798d2091"
#define S_CATE12722_PGID2
#define S_CATE12722_PGID3
#define S_CATE12722_PGID4
#define S_CATE12722_PGID5
#define S_CATE12722_PGID6

/**---------->WebsiteMap<----------*/
/*
Xttp://www.mei.com
                  /appapi
                         /home
                                 /event
                                 /marketBanner
                         /cart
                                 /viewCount
                         /silo
                                 /specialSilo
                                 /event
                         /version
                                 /update
                         /event
                                 /product
                         /catalog
                                 /list
                         /upcoming
                                 /index
                         /product
                                 /detail
                                 /description
                                 /qa
                                 /hot
                                 /review

*/
/**---------->WebsiteMap<----------*/


/**----------->首页<-----------*/
///home
#define MARKETINGBANNER @"http://www.mei.com/appapi/home/marketingBanner?summary=ab37c575dd399d014187f1c8c0d921a9"

///silo
//按silo类显示
#define SPECIALSILO @"http://www.mei.com/appapi/silo/specialSilo?summary=ab37c575dd399d014187f1c8c0d921a9"
/**--Andr...--*/
//@"http:\//www.mei.com/appapi/home/announce?summary=ab37c575dd399d014187f1c8c0d921a9"
//@"http:\//www.mei.com/appapi/silo/navigation?summary=ab37c575dd399d014187f1c8c0d921a9"
/**--       --*/

///event/
//按categoryId检索商品
//www.mei.com/appapi/event/product?categoryId=18969&pageIndex=1&sort=&summary=e39c7f03f0e1dd2f7d39198c4e3c4f1f
//how to？

///catalog
//获得silo类信息。
//www.mei.com/appapi/catalog/list?pageIndex=1&summary=438c356e9e5da294402f6c4300526180

///upcoming
//即将上线
#define UPCOMIMG @"http://www.mei.com/appapi/upcoming/index?summary=ab37c575dd399d014187f1c8c0d921a9"

///product
//商品详情页
//www.mei.com/appapi/product/detail?categoryId=18905&productId=767425&summary=6796d838bdc68de61aae19b2171ce07a
//www.mei.com/appapi/product/description?productId=767425&summary=ae87f642361c1b4cb9d079a5e4f6d9ef



