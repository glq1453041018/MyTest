//
//  NSObject+InitData.m
//  GuDaShi
//
//  Created by LOLITA on 2017/8/30.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "NSObject+InitData.h"
#import <objc/runtime.h>
#import "NSDictionary+Utility.h"
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
@implementation NSObject (InitData)

// !!!!: 字典转换为模型
+(instancetype)objectWithModuleDic:(NSDictionary *)moduleDic hintDic:(NSDictionary *)hintDic{
    NSObject *instance = [[[self class] alloc] init];
    unsigned int numIvars; // 成员变量个数
    Ivar *vars = class_copyIvarList([self class], &numIvars);
    NSString *key=nil;
    NSString *key_property = nil;  // 属性
    NSString *type = nil;
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  // 获取成员变量的名字
        key = [key hasPrefix:@"_"]?[key substringFromIndex:1]:key;   // 如果是属性自动产生的成员变量，去掉头部下划线
        key_property = key;
        
        // 映射字典,转换key
        if (hintDic) {
            key = [hintDic objectForKey:key]?[hintDic objectForKey:key]:key;
        }

        id value = [moduleDic objectForKeyNotNull:key];
       
        if (value==nil) {
            type = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]; //获取成员变量的数据类型
            // 列举了常用的基本数据类型，如果有其他的，需要添加
            if ([type isEqualToString:@"B"]||[type isEqualToString:@"c"]||[type isEqualToString:@"d"]||[type isEqualToString:@"i"]|[type isEqualToString:@"I"]||[type isEqualToString:@"f"]||[type isEqualToString:@"q"]||[type isEqualToString:@"f"]||[type isEqualToString:@"l"]||[type isEqualToString:@"Q"]) {
                value = @(0);
            }
        }
        
        [instance setValue:value forKey:key_property];
    }
    free(vars);
    return instance;
}


// !!!!: 模型转字典
-(NSDictionary *)changeToDictionaryWithHintDic:(NSDictionary *)hintDic{
    NSMutableDictionary *resDic = [NSMutableDictionary dictionary];
    unsigned int numIvars; // 成员变量个数
    Ivar *vars = class_copyIvarList([self class], &numIvars);
    NSString *key=nil;
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  // 获取成员变量的名字
        key = [key hasPrefix:@"_"]?[key substringFromIndex:1]:key;   // 如果是属性自动产生的成员变量，去掉头部下划线
        id value = [self valueForKey:key];
        if (value!=nil) {
            // 映射字典,转换key
            if (hintDic) {
                key = [hintDic objectForKey:key]?[hintDic objectForKey:key]:key;
            }
            [resDic setValue:value forKey:key];
        }
    }
    free(vars);
    return resDic;
}


// !!!!: 模型转json
-(NSString *)changeToJsonStringWithHintDic:(NSDictionary *)hintDic{
    NSDictionary *resDic = [self changeToDictionaryWithHintDic:hintDic];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resDic options:NSJSONWritingPrettyPrinted error:nil];
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return @"";
}




// !!!!: 一些描述信息
-(NSDictionary *)descriptionInfo{
    NSDictionary *dic = objc_getAssociatedObject(self, _cmd);
    if (dic==nil) {
        dic = [self changeToDictionaryWithHintDic:nil];
        objc_setAssociatedObject(self, @selector(descriptionInfo), dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}
-(void)setDescriptionInfo:(NSDictionary *)descriptionInfo{
    objc_setAssociatedObject(self, @selector(descriptionInfo), descriptionInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
