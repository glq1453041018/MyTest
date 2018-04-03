//
//  ClassSpaceTableViewCellDelegate.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/4/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ClassSpaceTableViewCellDelegate <NSObject>

@optional
-(void)classSpaceTableViewCellClickEvent:(ClassCellClickEvent)event;

@end
