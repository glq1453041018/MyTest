//
//  AddressSearchViewController.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/28.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
#import "AddressSearchDelegate.h"

@interface AddressSearchViewController : UIViewController

@property (copy ,nonatomic) NSArray *originArray;   // 原始数据数组

@property (nonatomic,weak) id <AddressSearchDelegate> delegate;

@end

