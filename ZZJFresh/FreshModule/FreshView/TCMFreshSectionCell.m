//
//  TCMFreshSectionCell.m
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/29.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import "TCMFreshSectionCell.h"
@interface TCMFreshSectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *marketLabel;

@end
@implementation TCMFreshSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TCMFreshMarketModel *)model{
    if (_model != model) {
        _model = model;
    }
    
    self.marketLabel.text = _model.market_name;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
