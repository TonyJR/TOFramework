//
//  TODicCache.m
//  CertificateTest
//
//  Created by TonyJR on 14-4-1.
//  Copyright (c) 2014年 Tony. All rights reserved.
//

#import "TOCache.h"
#import "CommonFunc.h"



@implementation TOCache

+(const char *)encryptStr{
    return "1ijklm58CYZaopbvDEx6NOnq9JKLBrstFGHcdI4PQRefghuSTAXwyz0U3+/V7WM2";
}


+(BOOL)existItem:(NSString *)key{
    NSString * path = [self filePath:key];
    
    return [self existPath:path];
}

+(BOOL)existPath:(NSString *)path{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }else{
        return NO;
    }
}

+(void)saveItemForKey:(id)item forKey:(NSString *)key{

    if (item) {
        NSString * path = [self filePath:key];

        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:item];
        data = [self encrypt:data];

        [data writeToFile:path atomically:YES];
    }else{
        [self deleteItemForKey:key];
    }
}
+(id)loadItemForKey:(NSString *)key{

    NSString * path = [self filePath:key];

    if ([self existPath:path]) {
        NSData * data = [NSData dataWithContentsOfFile:path];
        
        data = [self decrypt:data];
        id item = nil;
        @try {
            item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        @catch (NSException *exception) {
            NSLog(@"NSKeyedUnarchiver unarchiveObjectWithData Error!! %@",exception);
        }
        
        
        return item;
    }else{
        return nil;
    }
}
+(void)deleteItemForKey:(NSString *)key{
    NSString * path = [self filePath:key];
    
    if ([self existPath:path]) {
        NSError * error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
}

+(NSString *)filePath:(NSString *) key{

    NSString * item = __MD5(key);
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    
    NSString * result = [NSString stringWithFormat:@"%@/%@.dat",documentsDirectory,item];
    return result;
}

//加密算法
+(NSData *)encrypt:(NSData *)data{
    if (!data) {
        return nil;
    }
    
    
    int length = (int)data.length;
    if (length<=1) {
        return data;
    }
    Byte * p = (Byte *)[data bytes];
    
    for (int i=0; i<length; i++) {
        p[i] ^= p[(i+1)%length];
    }
    
    
    NSData * result = [[NSData alloc] initWithBytes:p length:length];
    NSString * temp = [CommonFunc base64EncodedStringFrom:result encryptStr:[self encryptStr]];
    
    result = [temp dataUsingEncoding:NSUTF8StringEncoding];
    return result;
}
//解密算法
+(NSData *)decrypt:(NSData *)data{
    if (!data) {
        return nil;
    }
    NSData * result = data;
    NSString * temp = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    result = [CommonFunc dataWithBase64EncodedString:temp encryptStr:[self encryptStr]];
    
    
    int length = (int)result.length;
    if (length<=1) {
        return data;
    }
    Byte * p = (Byte *)[result bytes];
    
    for (int i=length-1; i>=0; i--) {
        p[i] ^= p[(i+1)%length];
    }
    
    result = [[NSData alloc] initWithBytes:p length:length];
    return result;
}

@end
