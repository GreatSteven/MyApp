//
//  ViewController.m
//  MyApp
//
//  Created by 陈诚 on 16/9/29.
//  Copyright © 2016年 陈诚. All rights reserved.
//

#import "ViewController.h"
#import "GCStarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    GCStarView *starView = [[GCStarView alloc] initWithFrame:CGRectMake(0, 0, 200, 21)];
    starView.center = self.view.center;
    starView.scorePercent = 3;// 设置默认为选中3颗❤️
    [self.view addSubview:starView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
