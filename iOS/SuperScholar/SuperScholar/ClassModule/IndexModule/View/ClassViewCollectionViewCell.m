//
//  ClassViewCollectionViewCell.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassViewCollectionViewCell.h"
#import "ClassViewModel.h"
@implementation ClassViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
}


/*
 -(void)loadData:(NSArray *)data index:(NSInteger)index{
 ClassViewModel *cvm = data[index];
 self.titleLabel.text = cvm.name;
 UIImage *image = [UIImage imageNamed:cvm.icon];
 self.bgImageView.image = image;
 }
 */


@end
