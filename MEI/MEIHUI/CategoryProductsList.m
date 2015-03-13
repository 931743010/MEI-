//
//  CategoryProductsList.m
//  MEI
//
//  Created by Yosemite on 3/8/15.
//  Copyright (c) 2015 same.world. All rights reserved.
//

#import "CategoryProductsList.h"
#import "Network_RemoteDataLoad.h"
#import "URLCreate.h"

#define EDGEINTERVAL 5
#define CELLINTEVAL 10
@interface CategoryProductsList ()
{
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    NSMutableArray *_dataSource;
    Network_RemoteDataLoad *_netWorker;
    __block UICollectionView *_collectionView_;
}
@end

@implementation CategoryProductsList

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    CGFloat viewWidth = [[UIScreen mainScreen] bounds].size.width;
    if (!layout)
    {
        UICollectionViewFlowLayout *flowLayout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
        [flowLayout setMinimumLineSpacing:CELLINTEVAL];
        [flowLayout setMinimumInteritemSpacing:CELLINTEVAL];
        [flowLayout setItemSize:CGSizeMake((viewWidth - 3 * CELLINTEVAL) / 2, 1.777778 * (viewWidth - 3 * CELLINTEVAL) / 2)];
        [flowLayout setSectionInset:(UIEdgeInsets){EDGEINTERVAL, CELLINTEVAL, EDGEINTERVAL, CELLINTEVAL}];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout = flowLayout;
    }
    self = [super initWithCollectionViewLayout:layout];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    _viewHeight = [[self collectionView] bounds].size.height;
    _viewWidth = [[self collectionView] bounds].size.width;
    _netWorker = [Network_RemoteDataLoad new];
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    _collectionView_ = [self collectionView];
    [_collectionView_ setBounces:NO];
    // Register cell classes
    [self.collectionView registerClass:[ProductListCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [[self collectionView] setBackgroundColor:[UIColor colorWithRed:0.9 green:0.92 blue:0.91 alpha:1.0]];
    [self loadDataWithCategoryId:_categoryId pageIndex:0];
}

- (void)dealloc
{
    [_dataSource release];
    [_netWorker release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataWithCategoryId:(NSInteger)categoryId pageIndex:(NSInteger)index
{
    NSString *URLStr = [URLCreate getURLWithCategoryId:categoryId pageIndex:index];
    [_netWorker loadDataIgnoringL1CacheFromURLWithString:URLStr didFinishLoad:^(NSData *data) {
        NSDictionary *jdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *arr = [jdic objectForKey:@"products"];
        if (arr)
        {
            [_dataSource addObjectsFromArray:arr];
            [_collectionView_ reloadData];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    if ([cell tag] == 0)
    {
        [cell setTag:INT32_MAX];
        [[cell contentView] setBackgroundColor:[UIColor whiteColor]];
        CGFloat cellWidth = [cell bounds].size.width;
        CGFloat cellHeight = [cell bounds].size.height;
        UIImageView *imageShow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 0.75 * cellHeight)];
        UILabel *brandName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.75 * cellHeight, cellWidth, cellHeight / 16)];
        UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.8125 * cellHeight, cellWidth, cellHeight / 16)];
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.872 * cellHeight, cellWidth, 0.1 * cellWidth)];
        UILabel *marketPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.872 * cellHeight, cellWidth, 0.1 * cellWidth)];
        [cell setImageShow:imageShow];
        [cell setBrandName:brandName];
        [cell setProductName:productName];
        [cell setPrice:priceLabel];
        [cell setMarketPrice:marketPrice];
        [[cell contentView] addSubview:imageShow];
        [[cell contentView] addSubview:brandName];
        [[cell contentView] addSubview:productName];
        [[cell contentView] addSubview:priceLabel];
        [[cell contentView] addSubview:marketPrice];
        [imageShow release];
        [brandName release];
        [productName release];
        [priceLabel release];
        [marketPrice release];
    }
    NSInteger index = [indexPath row];
    [[cell brandName] setText:[_dataSource[index] objectForKey:@"brandName"]];
    [[cell productName] setText:[_dataSource[index] objectForKey:@"productName"]];
    [[cell price] setText:[_dataSource[index] objectForKey:@"price"]];
    [[cell marketPrice] setText:[_dataSource[index] objectForKey:@"marketPrice"]];
    [_netWorker loadDataFromURLWithString:[_dataSource[index] objectForKey:@"imageUrl"] didFinishLoad:^(NSData *data) {
        [[cell imageShow] setImage:[UIImage imageWithData:data]];
    }];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

@implementation ProductListCell

@end
