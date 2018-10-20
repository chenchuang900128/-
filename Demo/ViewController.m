//
//  ViewController.m
//  Demo
//
//  Created by 陈创 on 2018/10/20.
//  Copyright © 2018年 陈创. All rights reserved.
//

#import "ViewController.h"
#import "HCDragingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    HCDragingView *dragView = [[HCDragingView alloc] initWithFrame:CGRectMake(200, 300, 50, 50) containerView:self.view];
    dragView.dragImage = @"myIcon";
    dragView.badge = 3;
    dragView.didEventBlock = ^{
        
        NSLog(@"点击事件");
    };
    [dragView show];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
