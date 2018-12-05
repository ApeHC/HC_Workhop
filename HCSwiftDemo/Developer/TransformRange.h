//
//  TransformRange.h
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/11/28.
//  Copyright © 2018 HeChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransformRange : NSObject

+ (NSRange)getRangeWithText:(NSString *)text SubText:(NSString *)subText;

@end

NS_ASSUME_NONNULL_END
