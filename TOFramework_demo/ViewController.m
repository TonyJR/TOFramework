//
//  ViewController.m
//  TOFramework_demo
//
//  Created by Tony on 16/2/20.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "ViewController.h"
#import "TipManager.h"
#import "TOTask.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)submit:(id)sender{
    TOTask * task = [[TOTask alloc] initWithPath:@"http://daling.test.cmsthink.com/api/daling/login" parames:nil taskOver:^(TOTask *task) {
        [TipManager showTip:@"请求成功"];
    }];
    
    [task addParam:self.username.text forKey:@"username"];
    [task addParam:self.password.text forKey:@"password"];
    
    
    [task startAtOnce];
    
    
}

@end
