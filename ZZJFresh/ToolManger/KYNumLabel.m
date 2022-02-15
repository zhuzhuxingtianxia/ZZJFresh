//
//  KYNumLabel.m
//  ZZJFresh
//
//  Created by ZZJ on 2022/2/15.
//  Copyright © 2022 Jion. All rights reserved.
//

#import "KYNumLabel.h"

@interface KYNumLabelItem : NSObject

@property (nonatomic,assign)NSString *numberStr;
@property (nonatomic,assign)BOOL isNumber;

@property (nonatomic,assign)CGFloat positionY;
@property (nonatomic,assign)CGSize numSize;
@property (nonatomic,assign)NSInteger currentMidNumber;
@property (nonatomic,assign)NSInteger deltaNumber;
@property (nonatomic,assign)CGFloat fastSpeed;
@property (nonatomic,assign)CGFloat lowSpeed;

@end

@implementation KYNumLabelItem


@end


@interface KYNumLabel ()

@property (nonatomic,copy)NSArray *numArr;
@property (nonatomic,strong)UIFont *font;
@property (nonatomic,strong)UIColor *textColor;
@property (nonatomic,copy)NSString *numStr;

@property (nonatomic,assign)double duration;

@property (nonatomic,weak)CADisplayLink *displayLink;
@property (nonatomic,assign)CFAbsoluteTime startTime;
@property (nonatomic,assign)CFAbsoluteTime lastTime;

@property (nonatomic,assign)BOOL showText;

@end

@implementation KYNumLabel

+(instancetype)initWithFont:(UIFont *)font textColor:(UIColor *)textColor{
    return [self initWithNumArr:@"" font:font textColor:textColor];
}

+(instancetype)initWithNumArr:(NSString *)numStr
                         font:(UIFont *)font
                    textColor:(nonnull UIColor *)textColor{
    KYNumLabel *view = [[KYNumLabel alloc] init];
    view.font = font;
    view.textColor = textColor;
    view.numStr = numStr;
    view.opaque = NO;
    return view;
}

-(void)setNumStr:(NSString *)numStr{
    _numStr = numStr;
    NSInteger count = numStr.length;
    CGFloat lineHeight = _font.lineHeight;
    CGRect frame = self.frame;
    if (count == 0) {
        CGSize size = CGSizeMake(0, lineHeight + 0.5);
        frame.size = size;
        self.frame = frame;
    }
    UILabel *sizeLabel = [[UILabel alloc] init];
    sizeLabel.font = _font;
    sizeLabel.text = @"8";
    [sizeLabel sizeToFit];
    CGSize numSize = sizeLabel.frame.size;
    CGFloat width = 0;
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:count];
    for (int i=0; i<count; i++) {
        unichar ch = [numStr characterAtIndex:i];
        KYNumLabelItem *item = [[KYNumLabelItem alloc] init];
        item.isNumber = ch >= 48 && ch <= 57;
        item.numberStr = [NSString stringWithCharacters:&ch length:1];
        item.positionY = lineHeight;
        if (item.isNumber) {
            NSInteger number = ch - 48;
            NSInteger midNum = arc4random() % 10;
            item.currentMidNumber = midNum;
            NSInteger delNum = 9 - midNum + number;
            item.deltaNumber = delNum;
            item.numSize = numSize;
        }else{
            sizeLabel.text = item.numberStr;
            [sizeLabel sizeToFit];
            item.numSize = sizeLabel.frame.size;
        }
        [dataArr addObject:item];
        width += item.numSize.width;
    }
    _numArr = dataArr;
    CGSize size = CGSizeMake(width, lineHeight + 0.5);
    frame.size = size;
    self.frame = frame;
}

-(void)animateShowWithDuration:(double)duration{
    [_displayLink invalidate];
    _displayLink = nil;
    CGFloat lineHeight = _font.lineHeight;
    [_numArr enumerateObjectsUsingBlock:^(KYNumLabelItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item.isNumber) {
            CGFloat totalHeight = item.deltaNumber * lineHeight;
            item.fastSpeed = totalHeight * 0.66 / (duration * 0.6);
            item.lowSpeed = totalHeight * 0.34 / (duration * 0.4);
        }
    }];
    _duration = duration;
    _startTime = CFAbsoluteTimeGetCurrent();
    _lastTime = _startTime;
    _showText = YES;
    CADisplayLink *display = [CADisplayLink displayLinkWithTarget:self
                                                         selector:@selector(drawNums)];
    [display addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _displayLink = display;
}

-(void)drawNums{
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    UIColor *bgColor = self.backgroundColor ? self.backgroundColor : [UIColor whiteColor];
    [bgColor setFill];
    [[UIBezierPath bezierPathWithRect:rect] fill];
    if (!_showText) {
        return;
    }
    
    NSDictionary *drawDic = @{NSFontAttributeName:_font ? _font : [UIFont systemFontOfSize:12],
                              NSForegroundColorAttributeName:_textColor ? _textColor : [UIColor blackColor]
    };
    
    CGFloat lineHeight = _font.lineHeight;
    CGFloat startX = 0;
    double currentTime = CFAbsoluteTimeGetCurrent();
    double delTime = currentTime - _startTime;
    BOOL shouldDisplay = NO;
    for (int i=0; i<_numArr.count; i++) {
        KYNumLabelItem *item = _numArr[i];
        CGRect itemFrame = CGRectMake(startX, 0, item.numSize.width, item.numSize.height);
        
        //普通字符
        if (!item.isNumber) {
            [item.numberStr drawInRect:itemFrame withAttributes:drawDic];
            startX += item.numSize.width;
            continue;
        }
        
        //数字
        BOOL itemLayoutComplete = delTime >= _duration && item.currentMidNumber == item.numberStr.integerValue;
        if (itemLayoutComplete) {
            item.positionY = lineHeight;
        }
        NSString *midStr = @(item.currentMidNumber).stringValue;
        itemFrame.origin.y = item.positionY - lineHeight;
        [midStr drawInRect:itemFrame withAttributes:drawDic];
        NSInteger nextNum = (item.currentMidNumber + 1) % 10;
        if (item.positionY < lineHeight) {
            NSString *nextNumStr = [NSString stringWithFormat:@"%ld",nextNum];
            itemFrame.origin.y = item.positionY;
            [nextNumStr drawInRect:itemFrame withAttributes:drawDic];
        }
        startX += item.numSize.width;
        if (itemLayoutComplete == NO) {
            CGFloat speed = delTime <= (_duration * 0.6) ? item.fastSpeed : item.lowSpeed;
            item.positionY -= speed * (currentTime - _lastTime);
            if (item.positionY <= 0) {
                item.positionY = lineHeight;
                item.currentMidNumber = nextNum;
            }
            shouldDisplay = YES;
        }
    }
    _lastTime = currentTime;
    if (shouldDisplay == NO) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}


@end

