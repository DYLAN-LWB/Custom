//
//  ListTableViewCell.m
//  Custom
//
//  Created by 李伟宾 on 2016/10/28.
//  Copyright © 2016年 liweibin. All rights reserved.
//

#import "ListTableViewCell.h"

@interface ListTableViewCell ()
{
    UIImageView *_iconImageView;
    UILabel     *_titleLabel;
}
@end

@implementation ListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {

    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 10, 45, 45)];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 0, 200, 66)];
    [self.contentView addSubview:_titleLabel];
}

- (void)setListModelData:(ListModel *)listModelData {
    
    [_iconImageView setImageWithURL:[NSURL URLWithString:listModelData.titleimg]];
    _titleLabel.text = listModelData.title;
}

@end
