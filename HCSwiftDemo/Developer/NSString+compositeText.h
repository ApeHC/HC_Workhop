//
//  NSString+compositeText.h
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/11/27.
//  Copyright © 2018 HeChuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (compositeText)

+ (NSMutableAttributedString *)compositeTextWithText:(NSString *)text
                                           TextColor:(UIColor *)textColor
                                             SubText:(NSString *)subText
                                        SubTextColor:(UIColor *)subTextColor
                                            TextFont:(UIFont *)textFont;

@end

NS_ASSUME_NONNULL_END
