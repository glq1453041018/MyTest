//
//  SpeechViewController.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/21.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SpeechViewController : UIViewController

@property (assign ,nonatomic) NSInteger classId;    // 必须传递classId

-(void)lllistPickViewItemSelected:(NSInteger)index;

@end

