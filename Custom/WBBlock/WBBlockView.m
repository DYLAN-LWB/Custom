//
//  WBBlockView.m
//  Custom
//
//  Created by 李伟宾 on 2016/11/7.
//  Copyright © 2016年 liweibin. All rights reserved.
//

#import "WBBlockView.h"

@implementation WBBlockView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {

    CGFloat buttonW = SCREEN_WIDTH/3;
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonW*i, 0, buttonW, 55);
        button.tag = i;
        button.backgroundColor = i == 0 ? [UIColor redColor] : (i == 1 ? [UIColor yellowColor] : [UIColor blueColor]);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)buttonClick:(UIButton *)button {
    
    if (button.tag == 0) {
        
        self.type1();
        
    } else if (button.tag == 1) {
        
        self.type2(@"type2", @{ @"id": @"adfhakdjf"});
        
        self.IsParameterNoReturned2(@"333");
        
    } else {
        
        self.type3 = ^(NSString *string) {
            return [NSString stringWithFormat:@"---%@", string];
        };
    }

}


@end
