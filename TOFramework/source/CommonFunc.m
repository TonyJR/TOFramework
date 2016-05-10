//
//  CommonFunc.m
//  PRJ_base64
//
//  Created by TonyJR on 12-11-29.
//  Copyright (c) 2012年 com.comsoft. All rights reserved.
//

#import "CommonFunc.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>


//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

//空字符串
#define     LocalStr_None           @""

static const char * encodingTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation CommonFunc


+ (NSString *)textFromBase64String:(NSString *)base64 encryptStr:(const char *)encryptStr{
    if (base64 && ![base64 isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY   改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [self dataWithBase64EncodedString:base64 encryptStr:encryptStr];
        //IOS 自带DES解密 Begin    改动了此处
        //data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return LocalStr_None;
    }
}
+ (NSString *)base64StringFromText:(NSString *)text encryptStr:(const char *)encryptStr{
    if (text && ![text isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY  改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [self base64EncodedStringFrom:data encryptStr:encryptStr];
    }
    else {
        return LocalStr_None;
    }
}

+ (NSString *)base64StringFromText:(NSString *)text
{
    return [self base64StringFromText:text];
}

+ (NSString *)textFromBase64String:(NSString *)base64
{
    return [self textFromBase64String:base64];
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

+ (NSString *)base64EncodedStringFrom:(NSData *)data{
    return [self base64EncodedStringFrom:data encryptStr:encodingTable];
}
+ (NSData *)dataWithBase64EncodedString:(NSString *)string{
    return [self dataWithBase64EncodedString:string encryptStr:encodingTable];
}

/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
+ (NSData *)dataWithBase64EncodedString:(NSString *)string encryptStr:(const char *)encryptStr
{
    
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encryptStr[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data  encryptStr:(const char *)encryptStr
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encryptStr[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encryptStr[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encryptStr[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encryptStr[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}




//md5 16位加密 （大写）

+(NSString *)MD5:(NSString *)str {
    
    
    
    const char *cStr = [str UTF8String];
    
    
    
    unsigned char result[16];
    
    
    
    CC_MD5( cStr, strlen(cStr), result );
    
    
    
    return [NSString stringWithFormat:
            
            
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            
            
            result[0], result[1], result[2], result[3],
            
            
            
            result[4], result[5], result[6], result[7],
            
            
            
            result[8], result[9], result[10], result[11],
            
            
            
            result[12], result[13], result[14], result[15]
            
            
            
            ];
    
}

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    
    
    
    unsigned char result[32];
    
    CC_MD5( cStr, strlen(cStr), result );
    
    
    return [NSString stringWithFormat:
            
            
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            
            
            result[0],result[1],result[2],result[3],
            
            result[4],result[5],result[6],result[7],
            
            result[8],result[9],result[10],result[11],
            
            result[12],result[13],result[14],result[15]];

}


+(id)getItemByClassName:(NSString*)className{
    Class  c = [[NSBundle mainBundle] classNamed:className];
    
    id result = [[c alloc] init];
    return result;
}

/**
 *  获取字典中在parame对应key值的项
 *
 *  @param key    <#key description#>
 *  @param parame <#parame description#>
 *  @param dic    <#dic description#>
 *
 *  @return <#return value description#>
 */
+(id)getItemBykeyForParameFromDic:(NSString*)key parame:(NSString*)parame dic:(NSMutableDictionary * )dic{
    NSArray * arr = [dic allKeys];
    for (id k in arr) {
        if([dic[k] isKindOfClass:[NSMutableDictionary class]]){
            if ([dic[k][parame] isEqualToString:key]) {
                return dic[k];
            }
        }
    }
    
    return nil;
}

+(NSString *)getClassNameByItem:(id<NSObject>)item{
    
    return NSStringFromClass([item class]);
    
}

+ (BOOL)isJailbroken {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}

+ (SEL) selecterByName:(NSString *) selName{
    return NSSelectorFromString(selName);
}


+(void)object:(NSObject *)result setValueByDic:(NSDictionary *)dic{
    
    
    for (NSString * key in dic.allKeys) {
        [self object:result setValue:dic[key] forKey:key];
    }
}

//对对象的指定属性赋值
+(void)object:(NSObject *)result setValue:(id)value forKey:(NSString *)key{
    if ([value isEqual:[NSNull null]]) {
        value = @"";
    }
    
    if (key.length > 0) {
        NSString * keyName;
        
        NSString * setter ;
        if ([key isEqualToString:@"id"]) {
            //keyName = [NSString stringWithFormat:@"%@%@_%@",[[className substringToIndex:1] lowercaseString],[className substringFromIndex:1],key];
            keyName = @"_id";
        }else if ([key isEqualToString:@"description"]) {
            keyName = @"_description";
        }else{
            keyName = key;
        }
        
        if ([key isEqualToString:@"isfav"]) {
            
        }
        
        
        setter = [NSString stringWithFormat:@"set%@%@:",[[keyName substringToIndex:1] uppercaseString],[keyName substringFromIndex:1]];
        SEL selecter = NSSelectorFromString(setter);
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray * arr = [NSMutableArray array];
            NSArray * temp = value;
            for (int i=0; i<temp.count; i++) {
                id v = temp[i];

                if (v) {
                    [arr addObject:v];
                }
            }
            if ([result respondsToSelector:selecter]) {
                [result performSelector:selecter withObject:arr];

            }
            
        }else if([value isKindOfClass:[NSDictionary class]]){
            if ([result respondsToSelector:selecter]) {
                [result performSelector:selecter withObject:value];
                
            }
            
        }else {
            
            
            if ([result respondsToSelector:selecter]) {
                if ([value isKindOfClass:[NSString class]]) {
                    
                    
                    NSString * getter = keyName;
                    SEL selecterGetter = NSSelectorFromString(getter);
                    
                    //获取类型
                    Method method = class_getInstanceMethod([result class],selecterGetter);
                    char dst[10] ;
                    method_getReturnType(method,dst,10);
                    
                    
                    
                    if(dst[0] == '@'){
                        if (value == [NSNull null]) {
                            [result performSelector:selecter withObject:@""];
                        }else{
                            [result performSelector:selecter withObject:[value copy]];
                        }
                    }else{
                        NSNumber * number = [[[NSNumberFormatter alloc] init] numberFromString:value];
                        [self saveValueByType:dst[0] target:result selecter:selecter value:number];
                    }

                    
                }else if([value isKindOfClass:[NSNumber class]]){
                    
                    
                    NSString * getter = keyName;
                    SEL selecterGetter = NSSelectorFromString(getter);
                    
                    
                    //获取类型
                    Method method = class_getInstanceMethod([result class],selecterGetter);
                    char dst[10] ;
                    method_getReturnType(method,dst,10);
                    
                    [self saveValueByType:dst[0] target:result selecter:selecter value:value];
                    
                    
                }else {
                    [result performSelector:selecter withObject:[value copy]];
                }
            }else{
                //NSLog(@"warning !! there is no parame named '%@' in '%@'",key,[result class]);
            }
            
            
        }
    }
}
+(void)saveValueByType:(char)type target:(NSObject *)target selecter:(SEL)selecter value:(id)value{
    switch(type){
        case 73:{
            //"I" = 73 include : NSUInter ,unsigned int
            NSNumber * num = value;
            void (*setter)(id, SEL, uint);
            setter = (void(*)(id, SEL, uint))[target methodForSelector:selecter];
            
            setter(target, selecter, [num unsignedIntValue]);
            
            break;
        }
        case 76:{
            //"L" = 76 include : unsigned long
            NSNumber * num = value;
            void (*setter)(id, SEL, unsigned long);
            setter = (void(*)(id, SEL, unsigned long))[target methodForSelector:selecter];
            
            setter(target, selecter, [num unsignedLongValue]);
            
            break;
        }
        case 81:{
            //"Q" = 81 include : unsigned long long
            NSNumber * num = value;
            void (*setter)(id, SEL, unsigned long long);
            setter = (void(*)(id, SEL, unsigned long long))[target methodForSelector:selecter];
            
            setter(target, selecter, [num unsignedLongLongValue]);
            
            break;
        }
        case 83:{
            //"S" = 83 include : unsigned short
            NSNumber * num = value;
            void (*setter)(id, SEL, unsigned short);
            setter = (void(*)(id, SEL, unsigned short))[target methodForSelector:selecter];
            
            setter(target, selecter, [num unsignedShortValue]);
            
            break;
        }
        case 99:{
            //char "c" = 99 include : bool
            NSNumber * num = value;
            void (*setter)(id, SEL, BOOL);
            setter = (void(*)(id, SEL, BOOL))[target methodForSelector:selecter];
            
            setter(target, selecter, [num boolValue]);
            
            break;
        }
        case 100:{
            //double "d" = 100   include : double
            NSNumber * num = value;
            void (*setter)(id, SEL, double);
            setter = (void(*)(id, SEL, double))[target methodForSelector:selecter];
            
            setter(target, selecter, [num doubleValue]);
            
            break;
        }
        case 102:{
            //"f" = 102   include : float
            NSNumber * num = value;
            void (*setter)(id, SEL, float);
            setter = (void(*)(id, SEL, float))[target methodForSelector:selecter];
            
            setter(target, selecter, [num floatValue]);
            break;
        }
            
        case 105:{
            //"i" = 105 include : NSInter , int
            NSNumber * num = value;
            void (*setter)(id, SEL, int);
            setter = (void(*)(id, SEL, int))[target methodForSelector:selecter];
            
            setter(target, selecter, [num intValue]);
            break;
        }
        case 108:{
            //"l" = 108 include :   long ,
            NSNumber * num = value;
            void (*setter)(id, SEL, long);
            setter = (void(*)(id, SEL, long))[target methodForSelector:selecter];
            
            setter(target, selecter, [num longValue]);
            break;
        }
        case 113:{
            //"q" = 113 include :   long long ,
            NSNumber * num = value;
            void (*setter)(id, SEL, long long);
            setter = (void(*)(id, SEL, long long))[target methodForSelector:selecter];
            
            setter(target, selecter, [num longLongValue]);
            break;
        }
        case 115:{
            //"s" = 115 include :   short,
            NSNumber * num = value;
            void (*setter)(id, SEL, short);
            setter = (void(*)(id, SEL, short))[target methodForSelector:selecter];
            
            setter(target, selecter, [num shortValue]);
            break;
        }
        case 'B':{
            //"B" include : bool
            NSNumber * num = value;
            void (*setter)(id, SEL, BOOL);
            setter = (void(*)(id, SEL, BOOL))[target methodForSelector:selecter];
            
            setter(target, selecter, [num boolValue]);
            break;
        }
        case '@':{
            
            [target performSelector:selecter withObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
}

+(UIWindow *)alertWindow{
    NSArray * windows = [[UIApplication sharedApplication] windows];
    UIWindow * window = windows[0];
    
    for (int i=0; i<windows.count; i++) {
        UIWindow * temp = windows[i];
        if (temp.windowLevel == UIWindowLevelAlert) {
            window = temp;
            break;
        }
    }
    return window;
}


+(NSString *)pinyin:(NSString *)chinese{
    NSString * result;
    if ([chinese length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:chinese];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            result = [NSString stringWithFormat:@"%@",ms];
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            result = [NSString stringWithFormat:@"%@",ms];
        }
    }
    return result;
}

@end