//
//  NSString+compositeText.m
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/11/27.
//  Copyright © 2018 HeChuang. All rights reserved.
//

#import "NSString+compositeText.h"
#import <YYKit/YYKit.h>
@implementation NSString (compositeText)

+ (NSMutableAttributedString *)compositeTextWithText:(NSString *)text
                                    TextColor:(UIColor *)textColor
                                      SubText:(NSString *)subText
                                 SubTextColor:(UIColor *)subTextColor
                                     TextFont:(UIFont *)textFont{
    NSRange subRange = [text rangeOfString:subText];
    NSMutableAttributedString * attibutrdString = [[NSMutableAttributedString alloc] initWithString:text];
    [attibutrdString setColor:subTextColor range:subRange];
    [attibutrdString setFont:textFont];
    return attibutrdString;
}

@end
