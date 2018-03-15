//
//  MYBannerImageView.h
//  MYBannerScrollView
//
//  Created by 陈伟南 on 2016/10/21.
//  Copyright © 2016年 陈伟南. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYBannerImageView : UIControl

@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) UIImage *failImage;

@property (strong, nonatomic) NSLayoutConstraint *imageLeft;
@property (strong, nonatomic) NSLayoutConstraint *imageWidth;
@property (strong, nonatomic) NSLayoutConstraint *imageHeight;

- (void)loadImageWithImagePath:(NSString *)imagePath;

@end
