//
//  ViewController.m
//  collectionView02-瀑布流
//
//  Created by haifeng on 2018/9/17.
//  Copyright © 2018年 coderhong. All rights reserved.
//

#import "HTShopCell.h"
#import "HTShop.h"
#import "UIImageView+WebCache.h"

@interface HTShopCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation HTShopCell

- (void)setShop:(HTShop *)shop
{
    _shop = shop;
    
    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.价格
    self.priceLabel.text = shop.price;
}
@end
