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
// 主题色
#define KColorTheme HexColor(0x74d0c6)
// 选中的颜色
#define kSelectedColor KColorTheme
// 未选中的颜色
#define kNoselectColor HexColor(0x8a8a8a)
// 橙色
#define kDarkOrangeColor HexColor(0xFF8C00)
// 错误颜色
#define kErrorRedColor HexColor(0xFF5e5e)


//默认颜色
#define GLOBAL_TABLSECTION_LINECOLOR HexColor(0xc9ced6)
//分割线颜色
#define SeparatorLineColor  HexColor(0xe0e0e0)
//table背景颜色
#define TableBackGroundColor  HexColor(0xf7f7f7)
//选项卡的高度
#define kscrollerbarHeight 40

//字体大小
#define FontSize_16 16
#define FontSize_12 12
#define FontSize_13 13
#define FontSize_14 14
//字体颜色
#define FontSize_colorgray HexColor(0x333333)
#define FontSize_colordarkgray HexColor(0x666666)
#define FontSize_colorlightlightgray HexColor(0x888888)
#define FontSize_colorlightgray HexColor(0x999999)

//行间距
#define LineSpace 6.0

// 返回按钮
#define kGoBackImageString @"public_left"


#pragma mark - <************************** 通知字段 **************************>





#pragma mark - <************************** NSUserDefaults **************************>
static NSString *UserId_NSUserDefaults = @"userid";




#pragma mark - <************************** 枚举类型 **************************>




#pragma mark - <************************** 三方平台配置信息 **************************>
#define kMapKey @"b8bb72f6e81eff210cdae81d84d65c59"



#endif /* AppConfigInfo_h */
