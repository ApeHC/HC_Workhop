//
//  HCPlayerBottomBar.h
//  CreativeSpace
//
//  Created by HeChuang⌚️ on 2017/8/10.
//  Copyright © 2017年 HeChuang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KPLAYERUISIZE [UIScreen mainScreen].bounds.size

@class HCPlayerBottomBar;

@protocol HCPlayBottomBarDelegate <NSObject>
@required

/**
 进度slider'点击'

 @param controlView 底栏视图
 @param value 点击位置的Value
 */
- (void)controlView:(HCPlayerBottomBar *)controlView pointSliderLocationWithCurrentValue:(CGFloat)value;

/**
 进度slider'拖动'

 @param controlView 底栏视图
 @param slider slider
 */
- (void)controlView:(HCPlayerBottomBar *)controlView draggedPositionWithSlider:(UISlider *)slider;

/**
 全屏

 @param controlView 底栏视图
 @param button button
 */
- (void)controlView:(HCPlayerBottomBar *)controlView withLargeButton:(UIButton *)button;

@end

@interface HCPlayerBottomBar : UIView
/**
 进度当前值
 */
@property (nonatomic, assign) CGFloat currentValue;
/**
 最小值
 */
@property (nonatomic, assign) CGFloat minValue;
/**
 最大值
 */
@property (nonatomic, assign) CGFloat maxValue;
/**
 缓存当前值
 */
@property (nonatomic, assign) CGFloat bufferValue;
/**
 当前时间
 */
@property (nonatomic, copy) NSString * currentTime;
/**
 总时间
 */
@property (nonatomic, copy) NSString * totalTime;
/**
 屏幕按钮
 */
@property (nonatomic, strong) UIButton * screenButton;
/**
 进度条拖拽手势
 */
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, weak) id<HCPlayBottomBarDelegate> delegate;

@end
