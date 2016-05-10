
//
//  TORequestHelper.h
//  TOFramework
//
//  Created by TonyJR on 16/2/19.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOTask.h"

@interface TORequestHelper : NSObject


//HTTP请求帮助类（AFNetwork）
+(void)startTask:(nonnull TOTask *)task progress:(nullable void (^)(NSProgress * _Nonnull))progressHandler
        complete:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSData * _Nullable,NSError * _Nullable))completeHandler;

@end
