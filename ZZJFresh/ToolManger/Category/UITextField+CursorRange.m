//
//  UITextField+CursorRange.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/1/4.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "UITextField+CursorRange.h"
#import <objc/runtime.h>

@implementation UITextField (CursorRange)

- (NSRange)cursorRange{
    NSRange range = NSRangeFromString(objc_getAssociatedObject(self, @selector(cursorRange)));
    
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    range = NSMakeRange(location, length);
    
    return range;
    
}

- (void)setCursorRange:(NSRange)cursorRange{
    
    objc_setAssociatedObject(self, @selector(cursorRange), NSStringFromRange(cursorRange), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:cursorRange.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:cursorRange.location + cursorRange.length];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

@end
