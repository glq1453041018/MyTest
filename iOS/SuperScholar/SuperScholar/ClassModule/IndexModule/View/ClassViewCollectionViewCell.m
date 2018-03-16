//
//  ClassViewCollectionViewCell.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassViewCollectionViewCell.h"
#import "UIImage+ImageEffects.h"

@implementation ClassViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *image = [UIImage imageNamed:@"testimage"];
    self.bgImageView.image = [image applyBlurWithRadius:5 tintColor:[[[UIColor whiteColor] colorWithAlphaComponent:0.7] colorWithAlphaComponent:0.3] saturationDeltaFactor:1.0 maskImage:nil];
    
}

@end
