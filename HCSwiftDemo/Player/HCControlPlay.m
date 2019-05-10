//
//  HCControlPlay.m
//  CreativeSpace
//
//  Created by HeChuang⌚️ on 2017/8/14.
//  Copyright © 2017年 HeChuang. All rights reserved.
//

#import "HCControlPlay.h"
#import "Masonry.h"

@implementation HCControlPlay

- (void)drawRect:(CGRect)rect {
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imageBtn setImage:[UIImage imageNamed:@"HSMediaPlayerResource.bundle/play"] forState:UIControlStateNormal];
    [self.imageBtn setShowsTouchWhenHighlighted:YES];
    [self.imageBtn setImage:[UIImage imageNamed:@"HSMediaPlayerResource.bundle/pause"] forState:UIControlStateSelected];
    [self.imageBtn addTarget:self action:@selector(handleImageTapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.imageBtn];
    [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)handleImageTapAction:(UIButton *)button{
    button.selected = !button.selected;
    _state = button.isSelected ? YES : NO;
    if ([self.delegate respondsToSelector:@selector(pauseOrPlayView:withState:)]) {
        [self.delegate pauseOrPlayView:self withState:_state];
    }
}

@end
