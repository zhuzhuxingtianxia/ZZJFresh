//
//  TabBarController.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/1/23.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()
@property(nonatomic,assign)BOOL  isLogin;
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for (UIViewController *controller in self.viewControllers){
        
        [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        //正常图片 渲染模式
        controller.tabBarItem.image = [controller.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //点击图片
        controller.tabBarItem.selectedImage = [controller.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!_isLogin) {
        _isLogin = YES;
        //present操作需要在视图加载完成之后
        [self performSegueWithIdentifier:@"present" sender:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
