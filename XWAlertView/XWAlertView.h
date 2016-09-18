//
//  XWAlertView.h
//  XWAlertView
//
//  Created by 谢威 on 16/9/18.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWAlertView : UIView

-(instancetype)initWithTitle:(NSString *)title des:(NSString *)des btnArray:(NSArray *)btnArray;


- (void)showInView:(UIView *)view;


@end
