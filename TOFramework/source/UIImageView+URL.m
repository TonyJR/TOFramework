//
//  UIImageView+URL.m
//  TOTest
//
//  Created by Tony on 14-4-23.
//  Copyright (c) 2014年 PY. All rights reserved.
//

#import "UIImageView+URL.h"
#import "TONetwork.h"
#import <objc/runtime.h>

@implementation UIImageView (URL)

@dynamic url;

- (NSString *) url

{
    return objc_getAssociatedObject(self, @"UIImageView_url");
}




-(void)clearLoading{
    
    [[TONetwork sharedNetwork] stopTaskByKey:[NSString stringWithFormat:@"URLImage_%lld",(long long int)&self]];
    
}


-(void)setURL:(NSString *) url {
    [self setURL:url withPlaceHolder:nil withCache:NO];
}

-(void)setURL:(NSString *) url withCache:(BOOL)cache{
    [self setURL:url withPlaceHolder:nil withCache:cache];
}

-(void)setURL:(NSString *) url withPlaceHolder:(UIImage *)image withCache:(BOOL)cache{
    objc_setAssociatedObject(self, @"UIImageView_url", url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self clearLoading];
    
    if (url && url.length > 0) {
        
        NSData * data = [TONetwork cachedData:url];
        
        if (!data) {
            self.image = image;
            
            TOTask * task = [[TOTask alloc] initWithPath:url parames:nil owner:self taskOver:@selector(taskOverHandler:)];
            
            task.taskKey = [NSString stringWithFormat:@"URLImage_%lld",(long long int)&self];
            task.responseInfo = @"img";
            
            task.usingCache = cache;
            task.lockScreen = NO;
            [[TONetwork sharedNetwork] taskThread:task];
            
        }else{
            self.image = [UIImage imageWithData:data];
        }
    }
}


-(void)taskOverHandler:(TOTask *)task{
    if (![self.url isEqualToString:task.path]) {
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
    self.image = [UIImage imageWithData:task.responseData];
    [UIView commitAnimations];
}

@end
