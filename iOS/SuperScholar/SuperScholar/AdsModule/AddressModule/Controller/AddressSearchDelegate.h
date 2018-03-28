//
//  AddressSearchDelegate.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/28.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AddressModel.h"

@protocol AddressSearchDelegate <NSObject>

@optional
-(void)addressSearchController:(UIViewController*)ctrl cityModel:(AddressModel*)am;

@end
