//
//  UIView+ZJCopy.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/6/21.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "UIView+ZJCopy.h"

@implementation UIView (ZJCopy)
- (id)copy{
    NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    typeof(self) cpyObj = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
    return cpyObj;
}
@end

@implementation UITableView (ZJCopy)
- (id)copy{
    UITableView *table = [super copy];
    table.delegate = self.delegate;
    table.dataSource = self.dataSource;
    
    return table;
}
@end

@implementation UICollectionView (ZJCopy)
- (id)copy{
    UICollectionView *view = [super copy];
    view.delegate = self.delegate;
    view.dataSource = self.dataSource;
    
    return view;
}
@end
