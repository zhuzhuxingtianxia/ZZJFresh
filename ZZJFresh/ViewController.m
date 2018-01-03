//
//  ViewController.m
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import "ViewController.h"
#import "UIView+TCMEdgeSlide.h"
#import "UIView+TCMBasketAnimation.h"

#import "TCMFreshModel.h"

@interface ViewController ()
@property(nonatomic,strong)UIButton  *moveTopButton;
@property(nonatomic,strong)UIImageView *anImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 100, 40, 40);
    [button setImage:[UIImage imageNamed:@"timg.jpg"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [self.moveTopButton setImage:[UIImage imageNamed:@"timg.jpg"] forState:UIControlStateNormal];
    [self.moveTopButton edgeSliseWithSupView:self.view shakeLoopDuration:3.0];
    self.anImageView = [UIImageView new];
    self.anImageView.image = [UIImage imageNamed:@"mx"];
    self.anImageView.frame = CGRectMake(200, 200, 80, 80);
    [self.view addSubview:self.anImageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)freshEvtentAction:(id)sender {
    [self performSegueWithIdentifier:@"freshEvent" sender:sender];
    
}

-(void)clickAction{
    //[self.anView addToBasket:self.view moveToPoint:CGPointMake(20, 20)];
    
    [self.anImageView addProductsToShopCarAnimation:self.moveTopButton];
}

-(UIButton*)moveTopButton{
    if (!_moveTopButton) {
        _moveTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moveTopButton.translatesAutoresizingMaskIntoConstraints = NO;
        UIImage *img = [UIImage imageNamed:@"home_dig"];
        [_moveTopButton setImage:img forState:UIControlStateNormal];
        _moveTopButton.adjustsImageWhenHighlighted = NO;
        [_moveTopButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_moveTopButton];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[moveTopButton(width)]-20-|" options:0 metrics:@{@"width":@(img.size.width)} views:@{@"moveTopButton":_moveTopButton}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[moveTopButton(height)]-120-|" options:0 metrics:@{@"height":@(img.size.height)} views:@{@"moveTopButton":_moveTopButton,@"bottom":self.bottomLayoutGuide}]];
        
    }
    return _moveTopButton;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *controller = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"freshEvent"]) {
        controller.title = @"鲜活";
    }
    
    // Pass the selected object to the new view controller.
}

@end
