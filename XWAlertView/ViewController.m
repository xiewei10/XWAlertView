//
//  ViewController.m
//  XWAlertView
//
//  Created by 谢威 on 16/9/18.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import "ViewController.h"
#import "XWAlertView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)alertView:(UIButton *)sender {
    XWAlertView *view = [[XWAlertView alloc]initWithTitle:@"标题" des:@"这是描述 可以很长 反正都是只适应的 的萨的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达的萨达大" btnArray:@[@"iOS",@"python",@"java"]];
    
    [view showInView:self.view];
    
    
}



@end
