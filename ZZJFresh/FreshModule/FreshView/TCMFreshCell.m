//
//  TCMFreshCell.m
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import "TCMFreshCell.h"

@interface TCMFreshCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *standardLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originLabel;


@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property(nonatomic)BOOL btnEnabled;
@end

@implementation TCMFreshCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.addButton setImage:[UIImage imageNamed:@"store_huijia"] forState:UIControlStateHighlighted];
    self.btnEnabled = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)setModel:(TCMFreshModel *)model{
    if (_model != model) {
        _model = model;
    }
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:kDefaultImage];
    
    self.nameLabel.text = _model.goods_name;
    
    self.standardLabel.text = _model.standard_description;
    
    self.salesLabel.text = [NSString stringWithFormat:@"销量：%ld",[_model.goods_salenum integerValue]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[_model.goods_current_price floatValue]];
    
    self.originLabel.text = [NSString stringWithFormat:@"¥%.2f",[_model.goods_original_price floatValue]];
    
    //库存问题、限制数量、交易状态、商品库存类型
    
    
}

- (IBAction)addGoodsToBasket:(UIButton*)sender {
    NSLog(@"加入购物车");
    if (self.btnEnabled) {
        self.btnEnabled = NO;
        [self.deleagte addProducts:self.imgView goodsInfo:_model completion:^(BOOL flag) {
            self.btnEnabled = flag;
        }];
    }
    
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:228/255.0f green:227/255.0f blue:230/255.0f alpha:0.5].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5));
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
