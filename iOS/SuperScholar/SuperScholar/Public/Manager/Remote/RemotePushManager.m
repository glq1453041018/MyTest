//
//  RemotePushManager.m
//  GuDaShi
//
//  Created by 伟南 陈 on 2017/11/23.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "RemotePushManager.h"
#import <CloudPushSDK/CloudPushSDK.h>
//#import "SocketMsgHandleManager.h"
//#import "LiaoTianModle.h"
//#import "ShiPinBoFangViewController.h"
//#import "ZhiBoTiXingViewController.h"
//#import "MyZhiTiaoViewController.h"
//#import "GeguTuiJianZongViewController.h"
//#import "VideoAndAudioEntrance.h"
//#import "MyWebViewController.h"
//#import "ShouYeOenData.h"
//#import "WebViewViewController.h"
//#import "ZuHeViewController.h"
//
//#import "LLAlertView.h"                             // 弹窗视图
//#import "AdvertismentTipView.h"
//#import "HeadManager.h"
//
//#import "AuthorityManager.h"

//3纸条    13推票    20首页录播提醒     19首页直播提醒    14即将直播提醒      25活动预告   101文章页

static RemotePushManager *instance;

@interface RemotePushManager ()

@end

@implementation RemotePushManager

+ (instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


#pragma mark - <*********************** 远程推送消息处理 ************************>

//- (void)handleRemoteMessage:(id)userInfo{
//    if(userInfo == nil)
//    return;
//    
//    
//    UITabBarController *tab = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
//    UINavigationController *nav0 = tab.selectedViewController;
//    
//    //得到msgType
//    NSString *msgtype = [userInfo msgtype];
//    
//    if ([msgtype isEqualToString:@"3"]) {/*FIXME: 纸条数*/
//        //纸条数
//        [SocketMsgHandleManager defaultManager].messageNub++;
//        
//        MyZhiTiaoViewController *zhitiaoCtrl = [[MyZhiTiaoViewController alloc] initWithNibName:@"MyZhiTiaoViewController" bundle:nil andframe:CGRectZero];
//        zhitiaoCtrl.hidesBottomBarWhenPushed = YES;
//        [nav0 pushViewController:zhitiaoCtrl animated:YES];
//    }else if ([msgtype isEqualToString:@"13"])/*FIXME: 投资策略通知*/
//    {
//        //投资策略
//        [SocketMsgHandleManager defaultManager].messageNub++;
//        
//        GeGuTuiJianDataModle *p=userInfo;
//        NSInteger type = 0;
//        if([p.title containsString:@"建仓"])
//            type = 1;
//        else if([p.title containsString:@"个股追踪"])
//            type = 2;
//        else if([p.title containsString:@"平仓"])
//            type = 3;
//        
//        switch ([p.pushtype integerValue]) {
//            case 1:{//战区个股
//            }
//            break;
//            case 2:{//版本个股
//                // !!!: 重新获取用户信息
//                [MYPublicRequest getUserInfoWithCompletion:^(NSDictionary *userInfo) {
//                    GeguTuiJianZongViewController *next = [[GeguTuiJianZongViewController alloc]initWithNibName:@"GeguTuiJianZongViewController" bundle:nil];
//                    next.onlyShowDuanXian = p.stock_type == 1;//是否是短线票
//                    next.type = p.stock_type == 2 ? @"2" : @"1";
//                    next.subType = type;
//                    
//                    NSArray *banbenlist = userInfo[@"version_list"];
//                    if([banbenlist count] == 1 && [[banbenlist firstObject] integerValue] == 1){
//                        next.onlyShowDuanXian = YES;
//                    }
//                    
//                    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//                    UINavigationController *nav = (UINavigationController*)[(UITabBarController*)window.rootViewController selectedViewController];
//                    //                        if ([nav.topViewController isMemberOfClass:NSClassFromString(@"GeguTuiJianZongViewController")]) {
//                    //                            GeguTuiJianZongViewController *nav1 = (GeguTuiJianZongViewController*)nav.topViewController;
//                    //                            next.type = p.stock_type == 2 ? @"2" : @"1";
//                    //                            nav1.subType = type;
//                    //                            [nav1 reloadDataoutside];
//                    //                        }else{
//                    [nav pushViewController:next animated:YES];
//                    //                        }
//                } forced:NO];
//                
//                [[VideoAndAudioEntrance shareInstance] hide];
//                [[NSNotificationCenter defaultCenter] postNotificationName:LLALertView_SkipNotification object:@{
//                                                                                                                 @"type" : @"1",
//                                                                                                                 @"message" : @"版本个股弹窗"
//                                                                                                                 }];
//            }
//            break;
//            default:
//            break;
//        }
//    }else if ([msgtype isEqualToString:@"20"])/*FIXME: 首页录播提醒*/
//    {
//        //首页录播提醒
//        zhiboDataModel *p=userInfo;
//        NSString *Video_Id = [NSString stringWithFormat:@"%@",p.videoid];
//        [AuthorityManager requestStockSchoolAuthorityWithVideoId:Video_Id?Video_Id:@"" responseBlock:^(AuthorityModel *response, NSError *error) {
//            if(error == nil){//请求成功
//                if ([[AuthorityManager shareInstance] handleAuthorityResult:response orDictionary:nil]){
//                    ShiPinBoFangViewController *next = [[ShiPinBoFangViewController alloc] initWithNibName:@"ShiPinBoFangViewController" bundle:nil];
//                    next.nameString=p.Title;
//                    next.urlString= p.VideoUrl;
//                    next.Video_Id = [NSString stringWithFormat:@"%@",p.videoid];
//                    next.hidesBottomBarWhenPushed=YES;
//                    [nav0 presentViewController:next animated:YES completion:nil];
//                }
//            }else{//请求失败
////               LLAlertViewConfirm(error.code);
//            }
//        }];
//    }else if ([msgtype isEqualToString:@"19"])/*FIXME: 首页直播提醒*/
//    {
//        //首页直播提醒
//        [nav0 popViewControllerAnimated:NO];
//        [tab setSelectedIndex:1];//跳转到直播页面
//    }else if ([msgtype isEqualToString:@"14"])/*FIXME: 信封直播数*/
//    {
//        //直播数
//        [SocketMsgHandleManager defaultManager].messageNub++;
//        
//        ZhiBoTiXingViewController *next = [ZhiBoTiXingViewController new];
//        next.title=@"直播提醒";
//        next.hidesBottomBarWhenPushed=YES;
//        [nav0 pushViewController:next animated:YES];
//    }else if([msgtype isEqualToString:@"25"])/*FIXME: 活动预告*/
//    {
//        //活动预告弹窗
//        webUrlModel *model=userInfo;
//    
//        LLAlertView *llAlertView = [[LLAlertView alloc] init];
//        AdvertismentTipView *advertismentAlertView = [[[NSBundle mainBundle] loadNibNamed:@"AdvertismentTipView" owner:nil options:nil] firstObject];
//        [advertismentAlertView.showImageView sd_setImageWithURL:[NSURL URLWithString:model.bigimgurl]];
//        advertismentAlertView.linkurl = model.url;
//        llAlertView.contentView = advertismentAlertView;
//        llAlertView.touchToClose = YES;
//        llAlertView.needCloseBtn = YES;
//        
//        advertismentAlertView.AdvertismentClickBlock = ^(){
//            [llAlertView hide];
//        };
//        [llAlertView show];
//    }else if([msgtype isEqualToString:@"101"])/*FIXME:文章*/
//    {
//        articleModel *model = userInfo;
//        NSString *channelid = model.channelid;
//        switch ([channelid integerValue]) {
//            case 44:{//经典案例
//                NSString *liaJieStr=[NSString stringWithFormat:@"%@/AppPage/Anli/%@",YuMian,model.articleid];
//                WebViewViewController *arDetail = [[WebViewViewController alloc]initWithURLString:liaJieStr WithArticleId:[model.articleid intValue] WithArticleType:AnLiArticeType WithActionCallBack:nil];
//                arDetail.title = model.title ? model.title : @"正文页";
//                [nav0 pushViewController:arDetail animated:YES];
//            }
//                break;
//            default:{//普通文章
//                NSString *lianJieStr = [NSString stringWithFormat:@"%@/AppPage/Article/%@",YuMian,model.articleid];
//                WebViewViewController *arDetail = [[WebViewViewController alloc]initWithURLString:lianJieStr WithArticleId:[model.articleid intValue] WithArticleType:ptArticleType WithActionCallBack:nil];
//                arDetail.title = model.title ? model.title : @"正文页";
//                [nav0 pushViewController:arDetail animated:YES];
//            }
//                break;
//        }
//    }else if([msgtype isEqualToString:@"28"]){/*FIXME:组合推送*/
//        groupPushModle *model=userInfo;
//        UITabBarController *tab = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
//        UINavigationController *nav = [tab selectedViewController];
//        ZuHeViewController *vc = [[ZuHeViewController alloc] init];
//        vc.userid_t = [model.usersid_t integerValue];
//        vc.permissionTag = 1;
//        vc.teacherid = model.Teacher_Id;
//        vc.StockGroup_Id = model.StockGroup_Id;
//        NSString *title = @"组合";
//        vc.title = title;
//        vc.hidesBottomBarWhenPushed = YES;
//        [nav pushViewController:vc  animated:YES];
//    }
//}
//
//
- (id)changeSocketJsonInfoInToSocketModel:(NSDictionary *)jsonStr{
    // !!!: 将socket消息转为模型
    @synchronized (self) {
//        // 对得到的data值进行解析与转换即可
//        
//        /// 消息类型（0: 改用户类型 1：发言 2：回复 3：私信 4：老师回复（显示在右边） 5：财经更新   6：视频更新 7：股票推荐更新 8：客服用户 9：实时广播 10:私聊 11:重复登录 12:切换房间 13:股票推送 14:直播提醒 15:活动通知 16:房间人数广播 17:点赞 18:进出房间播报 19:直播时间提醒 20:录播时间提醒 22:大师金股 23.直播源的切换）
//        NSDictionary *responseJSON = jsonStr;
//        
//        LiaoTIanMsgType *hengQingModle=[[LiaoTIanMsgType alloc]initLiaoTIanMsgTypeData:responseJSON];//视频聊天
//        
//        if ([hengQingModle.msgtype isEqualToString:@"3"]) {/*FIXME: 纸条数*/
//            //纸条数
//            XinXiDataModle *p=[[XinXiDataModle alloc]initXinXiDataModleData:responseJSON];
//            p.msgtype = hengQingModle.msgtype;
//            return p;
//        }else if ([hengQingModle.msgtype isEqualToString:@"13"])/*FIXME: 投资策略通知*/
//        {
//            //投资策略
//            GeGuTuiJianDataModle *p=[[GeGuTuiJianDataModle alloc]initGeGuTuiJianDataModleData:responseJSON];
//            p.msgtype = hengQingModle.msgtype;
//            return p;
//        }else if ([hengQingModle.msgtype isEqualToString:@"20"])/*FIXME: 首页录播提醒*/
//        {
//            //首页录播提醒
//            zhiboDataModel *p=[[zhiboDataModel alloc]initZhiBoDataModle:responseJSON];
//            p.msgtype = hengQingModle.msgtype;
//            return p;
//        }else if ([hengQingModle.msgtype isEqualToString:@"19"])/*FIXME: 首页直播提醒*/
//        {
//            //首页直播提醒
//            zhiboDataModel *p=[[zhiboDataModel alloc]initZhiBoDataModle:responseJSON];
//            p.msgtype = hengQingModle.msgtype;
//            return p;
//        }else if ([hengQingModle.msgtype isEqualToString:@"14"])/*FIXME: 信封直播数*/
//        {
//            //直播数
//            XinXiDataModle *p=[[XinXiDataModle alloc]initXinXiDataModleData:responseJSON];
//            p.msgtype = hengQingModle.msgtype;
//            return p;
//        }else if ([hengQingModle.msgtype isEqualToString:@"25"])/*FIXME: 活动预告*/
//        {
//            //活动预告
//            webUrlModel *p=[[webUrlModel alloc]initWebUrlDataModle:responseJSON];
//            p.msgtype = hengQingModle.msgtype;
//            return p;
//        }else if ([hengQingModle.msgtype isEqualToString:@"101"])/*FIXME: 文章页*/
//        {
//            //文章页
//            articleModel *p=[[articleModel alloc]initArticleModle:responseJSON];
//            p.msgtype = hengQingModle.msgtype;
//            return p;
//        }else if([hengQingModle.msgtype isEqualToString:@"28"]){/*FIXME: 测试：组合推送*/
//            groupPushModle *model = [groupPushModle objectWithModuleDic:responseJSON hintDic:nil];
//            model.msgtype = hengQingModle.msgtype;
//            return model;
//        }
        return nil;
    }
}

- (void)bindAccountToAliPushServer{
//    [CloudPushSDK addAlias:userid withCallback:^(CloudPushCallbackResult *res) {
//        
//    }];
    NSString *userid = [NSString stringWithFormat:@"%ld", [AppInfo share].user.userId];
    [CloudPushSDK bindAccount:userid withCallback:^(CloudPushCallbackResult *res) {
        
    }];
}
- (void)unBindAccountToAliPushServer{
//    [CloudPushSDK removeAlias:userid withCallback:^(CloudPushCallbackResult *res) {
//        
//    }];
    [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
        
    }];
}

- (void)setBadgeNumberToAliPushServer:(NSInteger)number{
    [CloudPushSDK syncBadgeNum:number withCallback:^(CloudPushCallbackResult *res) {
        
    }];
}
@end
