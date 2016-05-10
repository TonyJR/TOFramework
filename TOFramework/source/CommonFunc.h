//
//  CommonFunc.h
//  PRJ_base64
//
//  Created by TonyJR on 12-11-29.
//  Copyright (c) 2012年 com.comsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define __BASE64( text )        [CommonFunc base64StringFromText:text]
#define __TEXT( base64 )        [CommonFunc textFromBase64String:base64]

#define __MD5( str )            [CommonFunc MD5:str]
#define IS_IOS7_OR_LATER        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_IOS8_OR_LATER        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_PAD                  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBA(rgbaValue) [UIColor colorWithRed:((float)((rgbaValue & 0xFF000000) >> 24))/255.0 green:((float)((rgbaValue & 0xFF0000) >> 16))/255.0 blue:((float)((rgbaValue & 0xFF00) >> 8))/255.0 alpha:((float)((rgbaValue & 0xFF) >> 0))/255.0]

@interface CommonFunc : NSObject

+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)textFromBase64String:(NSString *)base64;

+ (NSString *)textFromBase64String:(NSString *)base64 encryptStr:(const char *)encryptStr;
+ (NSString *)base64StringFromText:(NSString *)text encryptStr:(const char *)encryptStr;

+ (NSString *)base64EncodedStringFrom:(NSData *)data encryptStr:(const char *)encryptStr;
+ (NSData *)dataWithBase64EncodedString:(NSString *)string encryptStr:(const char *)encryptStr;

+ (NSString *)base64EncodedStringFrom:(NSData *)data;
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
//md5 16位加密 （大写）
+(NSString *)MD5:(NSString *)str ;
//md5 32位加密 （小写）
+(NSString *)md5:(NSString *)str ;


+(id)getItemByClassName:(NSString*)className;
+(id)getItemBykeyForParameFromDic:(NSString*)key parame:(NSString*)parame dic:(NSMutableDictionary * )dic;
+(NSString *)getClassNameByItem:(id<NSObject>)item;

+ (BOOL)isJailbroken;
+ (SEL) selecterByName:(NSString *) selName;
+ (void)object:(NSObject *)result setValueByDic:(NSDictionary *)dic;
+ (void)object:(NSObject *)result setValue:(id)value forKey:(NSString *)key;


+(UIWindow *)alertWindow;

+(NSString *)pinyin:(NSString *)chinese;
@end