//
//  XibCategory.h
//  XibOC
//
//  Created by 施峰磊 on 2020/2/29.
//  Copyright © 2020 施峰磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extend)
#pragma mark - UI
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;        //圆角

@property (nonatomic, assign)IBInspectable CGFloat borderWidth;         //线框宽度
@property (nonatomic, strong)IBInspectable UIColor *borderColor;        //线框颜色

@property (nonatomic, strong)IBInspectable UIColor *shadowColor;        //阴影颜色
@property (nonatomic, assign)IBInspectable CGFloat shadowOpacity;       //阴影不透明度
@property (nonatomic, assign)IBInspectable CGFloat shadowRadius;        //阴影半径
@property (nonatomic, assign)IBInspectable CGSize shadowOffset;         //阴影偏移量

@end

@interface UIButton (Extend)
@property (nonatomic, strong)IBInspectable UIColor *unEnabledColor;

@end

typedef enum : NSUInteger {
    StringTypeNone,
    StringTypeNumber,
    StringTypeChinese,
    StringTypeOther
} StringType;

@interface TypeString:NSObject
@property (nonatomic, assign) StringType type;
@property (nonatomic, strong) NSString *string;
@end

@interface NSString (Extend)
/// TODO:保留小数点位数
/// @param scale 小数点位数
- (NSString *)checkZeroScale:(NSInteger)scale;
@end

@interface UILabel (Extend)
@property (nonatomic, assign)IBInspectable BOOL isCheckZero;//是否检查小数位
@property (nonatomic, assign)IBInspectable NSInteger decimalPointLength;//小数位数，默认2位
@end

@interface UITextField (Extend)
@property (nonatomic, assign)IBInspectable BOOL isCheckPrice;//是否检查价格
@property (nonatomic, assign)IBInspectable BOOL isCheckPhone;//是否检查手机号码
@property (nonatomic, assign)IBInspectable NSInteger decimalPointLength;//小数位数，默认2位

@end

@interface UIColor (Extend)
/// TODO:十六进制颜色
/// @param hex 十六进制数字
/// @param a 透明度
+ (UIColor *)hex:(int32_t)hex a:(CGFloat)a;

/// TODO:颜色设置，兼容暗黑模式
/// @param lightColor 普通模式颜色
/// @param darkColor 暗黑模式颜色
+ (UIColor *)colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;
@end

NS_ASSUME_NONNULL_END
