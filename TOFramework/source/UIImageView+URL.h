//
//  UIImageView+URL.h
//  TOTest
//
//  Created by Tony on 14-4-23.
//  Copyright (c) 2014年 PY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (URL)

@property (nonatomic,strong) NSString * url;

-(void)setURL:(NSString *) url;
-(void)setURL:(NSString *) url withCache:(BOOL)cache;
-(void)setURL:(NSString *) url withPlaceHolder:(UIImage *)image withCache:(BOOL)cache;

-(void)clearLoading;

 

@end
