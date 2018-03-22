//
//  myTableView.m
//  GuDaShi
//
//  Created by gudashi_2 on 2017/9/15.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "myTableView.h"

@interface myTableView ()<UIGestureRecognizerDelegate>

@property (assign, nonatomic) BOOL canScroll;

@end
@implementation myTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
