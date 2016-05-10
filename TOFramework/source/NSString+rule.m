//
//  NSString+rule.m
//  mbankForPad
//
//  Created by TonyJR on 14-6-3.
//  Copyright (c) 2014年 PY. All rights reserved.
//

#import "NSString+rule.h"

@implementation NSString (rule)

//如果字符串为nil，返回空串；否则将原字符串头和尾去空格、tab、换行后返回
-(NSString *)rule{
    if (self == nil) {
        return @"";
    }
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}



-(NSString *)x:(NSString *)str{
    
    return [NSString stringWithFormat:@"%@%@",self,str];
}

-(NSString *)xi:(int)intValue{
    return [NSString stringWithFormat:@"%@%d",self,intValue];
}

//多个字符串拼接，以nil结束
-(NSString *) xx:(NSString *)s,...
{
    NSString *temp;
    id arg;
    va_list argList;
    if (s) {
        temp = [self stringByAppendingString:s];//s为第一个参数，第一个参数不在argList里
        va_start(argList, s);
        while ((arg = va_arg(argList, id)))
        {
            temp = [temp stringByAppendingString:arg];
        }
        va_end(argList);
    }
    return temp;
}

@end
