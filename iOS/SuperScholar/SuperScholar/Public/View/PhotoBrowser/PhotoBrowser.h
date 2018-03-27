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
 @return selectedView 为currentPage对应的视图，一般来说是一个imageView，关闭浏览器时会将这个视图移回原来的位置
 */
@optional
- (UIView *)photoBrowser:(PhotoBrowser *)photoBrowser didScrollToPage:(NSInteger)currentPage;

@end




@interface PhotoBrowser : UIView

@property (weak, nonatomic) id <PhotoBrowserDelegate> delegate;

/**
 加载本地图片
 
 @note selectedView 可选参数：一般来说是一个imageView，关闭浏览器时会将这个视图移回原来的位置
 */
+(instancetype)showLocalImages:(NSArray*)images selectedIndex:(NSInteger)index selectedView:(UIView *)selectedView;;

/**
 加载网络图片
 
 @note selectedView 可选参数：一般来说是一个imageView，关闭浏览器时会将这个视图移回原来的位置
 */
+(instancetype)showURLImages:(NSArray*)images placeholderImage:(UIImage *)image selectedIndex:(NSInteger)index  selectedView:(UIView *)selectedView;

@end

@interface PhotoBrowserCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *imageView;
@property (strong ,nonatomic) UIScrollView *scrollView;
@end




