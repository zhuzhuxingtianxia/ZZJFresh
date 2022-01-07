//
//  TCMNavigationController.m
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import "TCMNavigationController.h"

@implementation UIViewController (Navigation)

@end

@interface TCMNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation TCMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
- (void)initView{
    [self.navigationBar setBarTintColor:Color_Background_NO_1];
    [self.navigationBar setTintColor:Color_Background_NO_9];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)self.navigationBar.translucent = NO;
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:TCM_Font(18.0),NSForegroundColorAttributeName:Color_Background_NO_9}];
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) { // 不是第一个push进来的 左上角加上返回键
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"supermarkets_fh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerWhenHaveChildVC)];
        
        viewController.navigationItem.leftBarButtonItem = barButtonItem;
        viewController.hidesBottomBarWhenPushed = YES;
        self.interactivePopGestureRecognizer.delegate = self;
    }
    [super pushViewController:viewController animated:animated];
}


// 栈内有视图控制器时 弹出
- (void)popViewControllerWhenHaveChildVC{
    if ([self.topViewController respondsToSelector:@selector(popViewController)]) {
        [self.topViewController performSelector:@selector(popViewController)];
    }else if (self.childViewControllers.count>1) {
        [self popViewControllerAnimated:YES];
    }else {
        NSLog(@"Error: %s",__FUNCTION__);
    }
}


// 实现代理方法
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    // 判断如果不是根控制器 才需要pop返回手势
    return self.childViewControllers.count > 1;
}


- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    return [super popToRootViewControllerAnimated:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
