//
//  NSString+rule.h
//  mbankForPad
//
//  Created by TonyJR on 14-6-3.
//  Copyright (c) 2014年 PY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (rule)

@property (nonatomic,getter = rule,readonly)NSString * rule;
//首尾去空格/换行
-(NSString *)rule;
//字符串拼接
-(NSString *)x:(NSString *)str;
//字符串拼接数字
-(NSString *)xi:(int)intValue;
//多个字符串拼接，以nil结束
-(NSString *) xx:(NSString *)s,...;
@end
