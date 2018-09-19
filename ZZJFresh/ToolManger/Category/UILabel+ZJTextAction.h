//
//  UILabel+ZJTextAction.h
//  ZZJFresh
//
//  Created by ZZJ on 2018/9/17.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJTapActionDelegate <NSObject>
@optional
/**
 *  ZJTapActionDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index 点击的字符在数组中的index
 */
- (void)zj_attributeTapReturnString:(NSString *)string
                              range:(NSRange)range
                              index:(NSInteger)index;
@end

@interface UILabel (ZJTextAction)

/**
 *  是否打开点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL enabledTapEffect;

/**
 *  给文本添加点击事件Block回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param tapClick 点击事件回调
 */
- (void)zj_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings tapClicked:(void (^) (NSString *text, NSRange range, NSInteger index))tapClick;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate delegate
 */
- (void)zj_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings delegate:(id <ZJTapActionDelegate> )delegate;

@end

/*
 NSString *string1 = @"我同意";
 NSString *string2 = @"《服务协议》";
 NSString *string3 = @"《隐私权政策》";
 NSString *string = @"我同意《服务协议》和《隐私权政策》";
 
 NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string attributes:nil];
 
 NSRange rangeSever = NSMakeRange( string1.length,string2.length);
 [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangeSever];
 
 NSRange rangePrivacy = NSMakeRange( string.length - string3.length,string3.length);
 [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangePrivacy];
 
 self.protocolLabel.attributedText = attribute;
 //设置是否有点击效果，默认是YES
 self.protocolLabel.enabledTapEffect = NO;
 [self.protocolLabel zj_addAttributeTapActionWithStrings:@[string2,string3] tapClicked:^(NSString *text, NSRange range, NSInteger index) {
       NSLog(@"%@-%ld",text,index);
 }
 }];
 
 */
