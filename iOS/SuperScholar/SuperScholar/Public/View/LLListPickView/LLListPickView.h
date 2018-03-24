//
//  LLListPickView.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/21.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLListPickViewDelegate;
@interface LLListPickView : LLAlertView
@property (nonatomic,weak) id <LLListPickViewDelegate> delegate;

-(void)showItems:(NSArray*)items;

@end


@protocol LLListPickViewDelegate <NSObject>
@optional
-(void)lllistPickViewItemSelected:(NSInteger)index;
@end
