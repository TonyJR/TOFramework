//
//  TODicCache.h
//  CertificateTest
//
//  Created by TonyJR on 14-4-1.
//  Copyright (c) 2014年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOCache : NSObject

/**
 *  检查是否存在对象
 *
 *  @param key 对象关键字
 *
 *  @return 是否存在y/n
 */
+(BOOL)existItem:(NSString *)key;

/**
 *  保存对象
 *
 *  @param item 对象值，nullable 为空表示删除对象
 *  @param key  对象关键字
 */
+(void)saveItemForKey:(id)item forKey:(NSString *)key;

/**
 *  加载对象
 *
 *  @param key 对象关键字
 *
 *  @return 加载的内容
 */
+(id)loadItemForKey:(NSString *)key;

/**
 *  删除对象
 *
 *  @param key 对象关键字
 */
+(void)deleteItemForKey:(NSString *)key;


@end
