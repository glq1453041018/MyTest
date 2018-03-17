//
//  ClassInfoHeadView.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/15.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYBannerScrollView.h"

@interface ClassInfoHeadView : UIView

@property (weak, nonatomic) IBOutlet MYBannerScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
