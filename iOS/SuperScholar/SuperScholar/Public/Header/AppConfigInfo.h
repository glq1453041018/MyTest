//
//  AppConfigInfo.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#ifndef AppConfigInfo_h
#define AppConfigInfo_h

/*
    此文件放置应用的一些配置信息，包含提示、通知字段、NSUserDefaults字段等字段信息
 */

#pragma mark - <************************** 应用配置信息 **************************>
// 域名
#define YuMing @"http://118.24.146.251:8090"
#define YuMingAnd(urlString) [urlString hasPrefix:@"http"]?urlString:[NSString stringWithFormat:@"%@%@",YuMing,urlString]

// 主题色
#define KColorTheme HexColor(0x74d0c6)
// 主题字体的颜色
#define KColorTheme_font HexColor(0x20B2AA)  //#20B2AA   0x17B896
// 选中的颜色
#define kSelectedColor KColorTheme
// 未选中的颜色
#define kNoselectColor HexColor(0x8a8a8a)
// 橙色
#define kDarkOrangeColor HexColor(0xFF8C00)
// 深青色
#define kDarkCyanColor HexColor(0x008B8B)
// 错误颜色
#define kErrorRedColor HexColor(0xFF5e5e)


//默认颜色
#define GLOBAL_TABLSECTION_LINECOLOR HexColor(0xc9ced6)
//浅分割线颜色
#define SeparatorLineColor  HexColor(0xe0e0e0)
//深分割线颜色
#define SeparatorLineBoldColor  HexColor(0xd0d0d0)
//table背景颜色
#define TableBackGroundColor  HexColor(0xf7f7f7)
//选项卡的高度
#define kscrollerbarHeight 40

//字体大小
#define FontSize_12 12
#define FontSize_13 13
#define FontSize_14 14
#define FontSize_15 15
#define FontSize_16 17
//字体颜色
#define FontSize_colorgray HexColor(0x333333)
#define FontSize_colorgray_44 HexColor(0x444444)
#define FontSize_colordarkgray HexColor(0x666666)
#define FontSize_colorlightlightgray HexColor(0x888888)
#define FontSize_colorlightgray HexColor(0x999999)


//行间距
#define LineSpace 4.0

// 返回按钮
#define kGoBackImageString @"public_left"
//分享按钮
#define ShareImage @"shareImage"

// 默认的头像占位符
#define kPlaceholderHeadImage [UIImage imageNamed:@"bgImage"]
// 默认的图片占位符
#define kPlaceholderImage [UIImage imageNamed:@"zhanweifu"]





#pragma mark - <************************** 通知字段 **************************>
static NSString *AMapSearchCityCompletionNotification = @"AMapSearchCityCompletionNotification";            // 高德地图搜索城市完成通知







#pragma mark - <************************** NSUserDefaults **************************>
static NSString *UserInfo_NSUserDefaults    = @"userInfo";      // 用户信息










#pragma mark - <************************** 枚举类型 **************************>
// !!!: 班级类型
typedef NS_ENUM(NSInteger , MessageType) {
    MessageTypeDefault,             // 信息默认类型
    MessageTypeComment              // 评价信息类型 
};

// !!!: 多媒体的类型
typedef NS_ENUM(NSInteger , MediaType) {
    MediaTypePic,                   // 图文的
    MediaTypeVideo                  // 视频的
};

// !!!: 班级信息cell点击类型
typedef NS_ENUM(NSInteger , ClassCellClickEvent) {
    ClassCellHeadClickEvent,        // 头像
    ClassCellLikeClickEvent,        // 点赞
    ClassCellCommentClickEvent      // 评论
};

// !!!: 招聘类型，班级还是学校级别
typedef NS_ENUM(NSInteger , ReCruitType) {
    ReCruitTypeClass,               // 班级类型
    ReCruitTypeSchool               // 学校类型
};



#pragma mark - <************************** 模块code **************************>
static NSString* ZhaoShengQiShiCode                  = @"zsqs";          // 招生启示
static NSString* ZuiXinDongTaiCode                   = @"zxdt";          // 最新动态
static NSString* BanJiHuanJingCode                   = @"bjhj";          // 班级环境
static NSString* XueXiaoHuanJingCode                 = @"xxhj";          // 学校环境
static NSString* JingCaiHuoDongCode                  = @"jchd";          // 精彩活动
static NSString* HuoDongYuGaoCode                    = @"hdyg";          // 活动预告









#pragma mark - <************************** 三方平台配置信息 **************************>
#define kMapKey @"b8bb72f6e81eff210cdae81d84d65c59"



#endif /* AppConfigInfo_h */
