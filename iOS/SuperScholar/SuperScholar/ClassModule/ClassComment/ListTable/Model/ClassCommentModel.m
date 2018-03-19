//
//  ClassCommentModel.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassCommentModel.h"

@implementation ClassCommentModel

-(NSMutableArray *)picViews{
    if (_picViews==nil) {
        _picViews = [NSMutableArray array];
    }
    return _picViews;
}

-(UIView *)mediaView{
    if (_mediaView==nil) {
        _mediaView = [UIView new];
    }
    return _mediaView;
}


@end
