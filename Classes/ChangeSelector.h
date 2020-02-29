//
//  ChangeSelector.h
//  SRFont
//
//  Created by hlet on 2018/5/17.
//  Copyright © 2018年 hlet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeSelector : NSObject


/**
 TODO:替换实例方法
 
 @param class 类
 @param originalSelector 原始方法
 @param swizzledSelector 替换方法
 @return 结果
 */
+ (BOOL)exchangeInstanceMethodWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

/**
 TODO:替换类方法
 
 @param class 类
 @param originalSelector 原始方法
 @param swizzledSelector 替换方法
 @return 结果
 */
+ (BOOL)exchangeClassMethodWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
@end
