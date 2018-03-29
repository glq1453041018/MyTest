//
//  AddressViewController.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressSearchDelegate.h"

@interface AddressViewController : UIViewController
@property (nonatomic,weak) id <AddressSearchDelegate> delegate;
@end
