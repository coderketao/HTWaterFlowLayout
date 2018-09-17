//
//  ViewController.m
//  collectionView02-瀑布流
//
//  Created by haifeng on 2018/9/17.
//  Copyright © 2018年 coderhong. All rights reserved.
//

#import "DemoViewController.h"
#import "HTWaterFlowLayout.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "HTShop.h"
#import "HTShopCell.h"

@interface DemoViewController ()<UICollectionViewDataSource, HTWaterFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *shops;
@property (nonatomic, weak) UICollectionView *collectionView;

@end

static NSString *reuseIdentifier = @"shop";

@implementation DemoViewController

- (NSMutableArray *)shops {
    if (_shops == nil) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCollectooView];
    
    [self initRefresh];
}

- (void)initCollectooView {
    HTWaterFlowLayout *waterFlow = [[HTWaterFlowLayout alloc] init];
    waterFlow.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:waterFlow];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:@"HTShopCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview: _collectionView = collectionView];
}

- (void)initRefresh {
    // 下拉刷新
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    //进入页面自动刷新
    [self.collectionView.header beginRefreshing];
    
    // 上拉刷新
    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    _collectionView.footer.hidden = YES;
}

- (void)loadNewShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [HTShop objectArrayWithFilename:@"1.plist"];
        [self.shops removeAllObjects];
        
        [self.shops addObjectsFromArray:shops];
        
        [self.collectionView reloadData];
        
        [self.collectionView.header endRefreshing];
    });
}

- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [HTShop objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shops];
        
        [self.collectionView reloadData];
        
        [self.collectionView.footer endRefreshing];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionView.footer.hidden = self.shops.count == 0;
    return self.shops.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HTShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.shop = self.shops[indexPath.item];
    
    return cell;
}

- (CGFloat)waterFlowLayout:(HTWaterFlowLayout *)waterFlowLayout heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)itemWidth
{
    HTShop *shop = self.shops[indexPath.item];
    
    return itemWidth * shop.h / shop.w;
}

//- (CGFloat)columnCountInWaterflowLayout:(HTWaterFlowLayout *)waterflowLayout {
//    return 2;
//}
@end
