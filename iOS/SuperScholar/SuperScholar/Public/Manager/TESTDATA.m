//
//  TESTDATA.m
//  SuperScholar
//
//  Created by LOLITA on 18/3/20.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "TESTDATA.h"

@implementation TESTDATA

+(NSString *)randomContent{
    NSDictionary *dic = [self localDataDictionary];
    NSInteger randomNum = getRandomNumberFromAtoB(0, 49);
    NSArray *contents = [dic objectForKey:@"contents"];
    return contents[randomNum];
}


+(NSString *)randomUrlString{
    NSDictionary *dic = [self localDataDictionary];
    NSInteger randomNum = getRandomNumberFromAtoB(0, 49);
    NSArray *pics = [dic objectForKey:@"pics"];
    return pics[randomNum];
}


+(NSDictionary*)localDataDictionary{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"testData" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}


@end
