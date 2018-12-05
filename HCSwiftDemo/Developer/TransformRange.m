//
//  TransformRange.m
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/11/28.
//  Copyright © 2018 HeChuang. All rights reserved.
//

#import "TransformRange.h"

@implementation TransformRange

+ (NSRange)getRangeWithText:(NSString *)text SubText:(NSString *)subText{
    NSRange range = [text rangeOfString:subText];
    return range;
}

@end
