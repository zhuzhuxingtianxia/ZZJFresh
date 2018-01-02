//
//  TCMSectionScrollView.h
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/29.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCMSectionScrollView;
@protocol TCMSectionScrollViewDelegate <NSObject>

- (void)sectionScrollView:(TCMSectionScrollView *)view didSelectIndex:(NSIndexPath *)indexPath;

@end

@interface TCMSectionScrollView : UIView
/**  选中的item的索引值  */
@property(nonatomic,assign)NSInteger  selectIndex;

@property(nonatomic,weak)id<TCMSectionScrollViewDelegate> delegate;
/**  数据源  */
@property(nonatomic,strong)NSArray *sourceArray;


@end
