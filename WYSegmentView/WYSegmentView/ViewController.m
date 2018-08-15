//
//  ViewController.m
//  WYSegmentView
//
//  Created by wangyu on 2018/8/15.
//  Copyright © 2018 Wangyu. All rights reserved.
//

#import "ViewController.h"
#import "WYSegmentView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WYSegmentView *v = [WYSegmentView viewWithTitles:@[@"标题1", @"标题长一些2", @"标题长3", @"标题4"] frame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 50)];
    
    v.textColor = UIColor.grayColor;
    v.textColorHighlighted = UIColor.orangeColor;
    
    
    [self.view addSubview:v];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
