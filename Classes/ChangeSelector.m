//
//  ChangeSelector.m
//  SRFont
//
//  Created by hlet on 2018/5/17.
//  Copyright © 2018年 hlet. All rights reserved.
//

#import "ChangeSelector.h"
#import <objc/runtime.h>

@implementation ChangeSelector

/**
 TODO:替换实例方法
 
 @param class 类
 @param originalSelector 原始方法
 @param swizzledSelector 替换方法
 @return 结果
 */
+ (BOOL)exchangeInstanceMethodWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (!originalMethod || !swizzledMethod) {
        return NO;
    }
    
    BOOL didAddMethod=class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    return YES;
}


/**
 TODO:替换类方法
 
 @param class 类
 @param originalSelector 原始方法
 @param swizzledSelector 替换方法
 @return 结果
 */
+ (BOOL)exchangeClassMethodWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    if (!originalMethod || !swizzledMethod) {
        return NO;
    }
    
    Class metaClass = object_getClass(class);
    BOOL didAddMethod=class_addMethod(metaClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(metaClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    return YES;
}
@end
