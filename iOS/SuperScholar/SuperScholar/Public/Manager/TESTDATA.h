//
//  TESTDATA.h
//  SuperScholar
//
//  Created by LOLITA on 18/3/20.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TESTDATA : NSObject

+(NSString*)randomContent;

+(NSArray*)randomContents:(NSInteger)count;

+(NSString*)randomUrlString;

+(NSArray*)randomUrls:(NSInteger)count;

@end
