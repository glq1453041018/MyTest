//
//  NSObject+InitData.h
//  GuDaShi
//
//  Created by LOLITA on 2017/8/30.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (InitData)

/*
 模型信息
 */
@property (strong ,nonatomic) NSDictionary *descriptionInfo;


// !!!!: 字典转换为模型
/**
 模型初始化
 
 @param moduleDic 模型字典
 @param hintDic 映射字典
 @return 结果
 */
+(instancetype)objectWithModuleDic:(NSDictionary*)moduleDic hintDic:(NSDictionary*)hintDic;


// !!!!: 模型转字典
/**
 
 
 @param hintDic 映射字典，如果不需要则nil
 @return 结果字典
 */
-(NSDictionary*)changeToDictionaryWithHintDic:(NSDictionary*)hintDic;


// !!!!: 模型转json
/**
 模型转josn
 
 @param hintDic 映射字典
 @return 结果json
 */
-(NSString*)changeToJsonStringWithHintDic:(NSDictionary*)hintDic;



@end
