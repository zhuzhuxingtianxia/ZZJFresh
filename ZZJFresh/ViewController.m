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
#import "UITextField+CursorRange.h"

#import "TCMFreshModel.h"

@interface ViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UIButton  *moveTopButton;
@property(nonatomic,strong)UIImageView *anImageView;

@property (weak, nonatomic) IBOutlet UITextField *field;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self buildView];

}

-(void)buildView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 100, 40, 40);
    [button setImage:[UIImage imageNamed:@"timg.jpg"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(animatinAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self.moveTopButton setImage:[UIImage imageNamed:@"timg.jpg"] forState:UIControlStateNormal];
    [self.moveTopButton edgeSliseWithSupView:self.view shakeLoopDuration:3.0];
    self.anImageView = [UIImageView new];
    self.anImageView.image = [UIImage imageNamed:@"mx"];
    self.anImageView.frame = CGRectMake(150, 200, 80, 80);
    [self.view addSubview:self.anImageView];
    
    //设置光标颜色
    self.field.tintColor = [UIColor orangeColor];
    
}

#pragma mark -- UITextFieldDelegate

 //MARK: 1
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *textStr = textField.text;
    if (textStr.length%5 == 4 && string.length>0){
        textField.text = [textStr stringByAppendingString:@" "];
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    //因为中间有间隔5个就是22+5=27 才能确保是最多22位卡号数字
    if ([toBeString length] > 27){
        
        textField.text = [toBeString substringToIndex:27];
        
        return NO;
        
    }
    
    return YES;
}

-(void)dealloc{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

static BOOL change;
-(void)animatinAction:(UIButton*)sender{
    if (!change) {
        change = YES;
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
            sender.bounds = CGRectMake(0, 0, 50, 50);
            
        } completion:^(BOOL finished) {
            
        }];
    }else{
        change = NO;
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
            sender.bounds = CGRectMake(0, 0, 40, 40);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (IBAction)freshEvtentAction:(UIButton*)sender {
    if (sender.tag == 1) {
        id vc = [[NSClassFromString(@"ZJFreshController") alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self performSegueWithIdentifier:@"freshEvent" sender:sender];
    }
    
}
- (IBAction)dissmiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)clickAction{
    //[self.anView addToBasket:self.view moveToPoint:CGPointMake(20, 20)];
    
    [self.anImageView addProductsToShopCarAnimation:self.moveTopButton completion:^(BOOL flag) {
        
    }];
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
