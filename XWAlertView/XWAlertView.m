//
//  XWAlertView.m
//  XWAlertView
//
//  Created by 谢威 on 16/9/18.
//  Copyright © 2016年 成都卓牛科技. All rights reserved.
//

#import "XWAlertView.h"
#define KTitleH 30
#define KBtnH 44
#define KLineH 1
#define KMagin 20

@interface XWAlertView ()

@property (nonatomic,strong)UIView      *contaierView;
@property (nonatomic,strong)UILabel     *titleLable;
@property (nonatomic,strong)UILabel     *desLable;
@property (nonatomic,copy)NSString      *title;
@property (nonatomic,copy)NSString      *DesTitle;
@property (nonatomic,copy)NSArray       *btnArray;


@end

@implementation XWAlertView

- (instancetype)initWithTitle:(NSString *)title des:(NSString *)des btnArray:(NSArray *)btnArray{
    
    if (self == [super init]) {
        self.title = title;
        self.DesTitle = des;
        self.btnArray = btnArray;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
        [self config];
    
    }
    
    return self;
}

- (void)config{
    CGFloat KscrenW = self.frame.size.width;
    CGFloat KscrenH = self.frame.size.height;
    // 容器
    // 计算描述文字的高度
    CGFloat desMagin = ((KscrenW-KMagin *2)-KMagin*2);
    
    // 这里算出描述内容的高度
    CGFloat h = [self.DesTitle boundingRectWithSize:CGSizeMake(desMagin, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height;
    
    CGFloat contaierH = KTitleH+h+KLineH+KBtnH+10;
    
    // 这是容器
    self.contaierView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(KMagin ,(KscrenH-contaierH)/2,(KscrenW-KMagin*2),contaierH)];
        view.backgroundColor = [[UIColor purpleColor]colorWithAlphaComponent:.8];
        view.layer.cornerRadius = 5;
        [self addSubview:view];
        view;
    });
    
    // 标题
   self.titleLable = ({
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.contaierView.frame),KTitleH)];
        lable.text = self.title;
        lable.font = [UIFont systemFontOfSize:15];
        lable.textColor = [UIColor whiteColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable;
    });
    [self.contaierView addSubview:self.titleLable];
    
    self.desLable = ({
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(KMagin,KTitleH,desMagin,h)];
        lable.text = self.DesTitle;
        lable.font = [UIFont systemFontOfSize:12];
        lable.textColor = [UIColor whiteColor];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.numberOfLines = 0;
        lable;
    });
    [self.contaierView addSubview:self.desLable];
    
    // 线
    UIView *line = ({
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.desLable.frame)+10,CGRectGetWidth(self.contaierView.frame),KLineH)];
        view.backgroundColor = [UIColor greenColor];
        view;
    });
    [self.contaierView addSubview:line];
    
    // 按钮
    for (int i = 0; i < self.btnArray.count; i ++) {
        // 按钮
        CGFloat btnY = CGRectGetMaxY(line.frame);
        CGFloat btnW = CGRectGetWidth(self.contaierView.frame)/self.btnArray.count;
        CGFloat btnH = KBtnH;
        CGFloat btnX = btnW*i;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.btnArray[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contaierView addSubview:btn];
        if (i != self.btnArray.count-1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame),btnY,1,btnH)];
            line.backgroundColor = [UIColor greenColor];
            [self.contaierView addSubview:line];
            
        }
        
        
    }
    
}
- (void)showInView:(UIView *)view{
    [view addSubview:self];
    [self toAnimation];
    
}


- (void)btnClick:(UIButton *)sender{
    [self dismissAnimation];
    
}

#pragma mark ---- 动画
#pragma mark -- 出现
- (void)toAnimation{
    // 先截图
    UIView *snapView = [self.contaierView snapshotViewAfterScreenUpdates:YES];
    
    // 隐藏容器中的子控件
    for (UIView *view in self.contaierView.subviews) {
        view.hidden = YES;
    }
    self.contaierView.backgroundColor = [[UIColor purpleColor]colorWithAlphaComponent:0];
    // 保存x坐标的数组
    NSMutableArray *xArray = [[NSMutableArray alloc] init];
    // 保存y坐标
    NSMutableArray *yArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.contaierView.bounds.size.width; i = i + 10) {
        [xArray addObject:@(i)];
    }
    for (NSInteger i = 0; i < self.contaierView.bounds.size.height; i = i + 10) {
        [yArray addObject:@(i)];
    }
    
    
    //这个保存所有的碎片
    NSMutableArray *snapshots = [[NSMutableArray alloc] init];
    for (NSNumber *x in xArray) {
        
        for (NSNumber *y in yArray) {
            CGRect snapshotRegion = CGRectMake([x doubleValue], [y doubleValue], 10, 10);
            
            // resizableSnapshotViewFromRect 这个方法就是根据frame 去截图
            UIView *snapshot      = [snapView resizableSnapshotViewFromRect:snapshotRegion afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            snapshot.frame        = snapshotRegion;
            [self.contaierView addSubview:snapshot];
            [snapshots         addObject:snapshot];
        }
    }
    
    for (UIView *view in snapshots) {
        view.transform = CGAffineTransformMakeTranslation([self randomRange:100 offset:0],[self randomRange:200 offset:100]);
    }
    
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
                         for (UIView *view in snapshots) {
                             // 让碎片回到原来的frame
                             view.transform = CGAffineTransformIdentity;
                         }
                     }
                     completion:^(BOOL finished) {
                         for (UIView *view in snapshots) {
                             // 移除碎片
                             [view removeFromSuperview];
                         }
                         for (UIView *view in self.contaierView.subviews) {
                             view.hidden = NO ;
                         }
                         self.contaierView.backgroundColor = [[UIColor purpleColor]colorWithAlphaComponent:1];
                         
                     }];
    
    
}
#pragma mark -- 消失
-(void)dismissAnimation{
    
    // 先截图
    UIView *snapView = [self.contaierView snapshotViewAfterScreenUpdates:YES];
    
    // 隐藏容器中的子控件
    for (UIView *view in self.contaierView.subviews) {
        view.hidden = YES;
    }
    self.contaierView.backgroundColor = [[UIColor purpleColor]colorWithAlphaComponent:0];
    // 保存x坐标的数组
    NSMutableArray *xArray = [[NSMutableArray alloc] init];
    // 保存y坐标
    NSMutableArray *yArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.contaierView.bounds.size.width; i = i + 10) {
        [xArray addObject:@(i)];
    }
    for (NSInteger i = 0; i < self.contaierView.bounds.size.height; i = i + 10) {
        [yArray addObject:@(i)];
    }
    
    
    //这个保存所有的碎片
    NSMutableArray *snapshots = [[NSMutableArray alloc] init];
    for (NSNumber *x in xArray) {
        
        for (NSNumber *y in yArray) {
            CGRect snapshotRegion = CGRectMake([x doubleValue], [y doubleValue], 10, 10);
            
            // resizableSnapshotViewFromRect 这个方法就是根据frame 去截图
            UIView *snapshot      = [snapView resizableSnapshotViewFromRect:snapshotRegion afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            snapshot.frame        = snapshotRegion;
            [self.contaierView addSubview:snapshot];
            [snapshots         addObject:snapshot];
        }
    }
    
    
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                        animations:^{
                         self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
                         for (UIView *view in snapshots) {
                            view.frame = CGRectOffset(view.frame, [self randomRange:200 offset:-100], [self randomRange:200 offset:self.frame.size.height/2]);
                         }
                     }
                     completion:^(BOOL finished) {
                         for (UIView *view in snapshots) {
                             [view removeFromSuperview];
                         }
                         [self.contaierView removeFromSuperview];
                         [self removeFromSuperview];
                         
                     }];

    
    
    
}




- (CGFloat)randomRange:(NSInteger)range offset:(NSInteger)offset{
    
    return (CGFloat)(arc4random()%range + offset);
}




@end
