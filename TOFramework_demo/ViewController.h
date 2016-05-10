//
//  ViewController.h
//  TOFramework_demo
//
//  Created by Tony on 16/2/20.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,strong) IBOutlet UITextField * username;
@property (nonatomic,strong) IBOutlet UITextField * password;

-(IBAction)submit:(id)sender;
@end

