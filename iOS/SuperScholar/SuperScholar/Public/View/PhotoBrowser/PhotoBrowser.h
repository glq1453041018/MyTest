//
//  PhotoBrowser.h
//  PhotoBrowser
//
//  Created by LOLITA on 2017/8/31.
//  Copyright © 2017年 LOLITA0164. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoBrowser;

@protocol PhotoBrowserDelegate <NSObject>

/**
 图片浏览器切换图片通知，目的：获取关闭浏览器图片后，需要移回的fromFrame

 @param photoBrowser 图片浏览器
 @param currentPage 当前图片下标
 @return fromFrame 为currentPage对应的图片，使用convertRect映射到window上的frame
 */
@optional
- (CGRect)photoBrowser:(PhotoBrowser *)photoBrowser didScrollToPage:(NSInteger)currentPage;

@end




@interface PhotoBrowser : UIView

@property (weak, nonatomic) id <PhotoBrowserDelegate> delegate;

/**
 加载本地图片
 
 @note fromFrame 可选参数：关闭浏览器图片需要移回的frame，即当前图片使用convertRect映射到window上的frame
 */
+(instancetype)showLocalImages:(NSArray*)images selectedIndex:(NSInteger)index  fromFrame:(CGRect)fromFrame;

/**
 加载网络图片
 
 @note fromFrame 可选参数：关闭浏览器图片需要移回的frame，即当前图片使用convertRect映射到window上的frame
 */
+(instancetype)showURLImages:(NSArray*)images placeholderImage:(UIImage *)image selectedIndex:(NSInteger)index  fromFrame:(CGRect)fromFrame;

@end

@interface PhotoBrowserCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *imageView;
@property (strong ,nonatomic) UIScrollView *scrollView;
@end




