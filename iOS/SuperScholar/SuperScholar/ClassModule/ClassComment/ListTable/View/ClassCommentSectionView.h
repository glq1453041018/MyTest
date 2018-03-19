//
//  ClassCommentSectionView.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassCommentSectionViewDelegate <NSObject>
@optional
-(void)classCommentSectionViewSelectedIndex:(NSInteger)index content:(NSString*)content;
@end

@interface ClassCommentSectionView : UIView

-(void)loadData:(NSArray*)types withDelegate:(id)delegate;

@end
