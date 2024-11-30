#import "XibCategory.h"
#import "ChangeSelector.h"
#import <objc/runtime.h>

@implementation UIView (Extend)
#pragma mark - UI
- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)borderWidth{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}


- (UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)shadowColor{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setShadowColor:(UIColor *)shadowColor{
    self.layer.shadowColor = shadowColor.CGColor;
}

- (CGFloat)shadowOpacity{
    return self.layer.shadowOpacity;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity{
    self.layer.shadowOpacity = shadowOpacity;
}

- (CGSize)shadowOffset{
    return self.layer.shadowOffset;
}

- (void)setShadowOffset:(CGSize)shadowOffset{
    self.layer.shadowOffset = shadowOffset;
}

- (CGFloat)shadowRadius{
    return self.layer.shadowRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius{
    self.layer.shadowRadius = shadowRadius;
}

@end


@implementation UIButton (Extend)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //set方法替换
        [ChangeSelector exchangeInstanceMethodWithClass:[self class] originalSelector:@selector(setEnabled:) swizzledSelector:@selector(setTheEnabled:)];
        [ChangeSelector exchangeInstanceMethodWithClass:[self class] originalSelector:@selector(setBackgroundColor:) swizzledSelector:@selector(setTheBackgroundColor:)];
    });
}

- (UIColor *)unEnabledColor{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUnEnabledColor:(UIColor *)unEnabledColor{
    objc_setAssociatedObject(self, @selector(unEnabledColor), unEnabledColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.enabled && unEnabledColor) {
        self.backgroundColor = unEnabledColor;
    }
}

- (UIColor *)enabledColor{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEnabledColor:(UIColor *)enabledColor{
    objc_setAssociatedObject(self, @selector(enabledColor), enabledColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.enabled && enabledColor) {
        self.backgroundColor = enabledColor;
    }
}

- (void)setTheBackgroundColor:(UIColor *)backgroundColor{
    [self setTheBackgroundColor:backgroundColor];
    if ([self enabledColor] == nil) {
        [self setEnabledColor:backgroundColor];
    }
}

- (void)setTheEnabled:(BOOL)enabled{
    [self setTheEnabled:enabled];
    UIColor *color;
    if (enabled) {
        color = [self enabledColor];
    }else{
        color = [self unEnabledColor];
    }
    if (color) {
        self.backgroundColor = color;
    }
}

@end

@implementation TypeString

- (instancetype)init{
    self = [super init];
    if (self) {
        _string = @"";
    }
    return self;
}

@end

@implementation NSString (Extend)

- (NSArray *)numberTypeSplit{
    return @[];
}

/// TODO:字符串精度控制
/// @param scale 多少位小数点
- (NSString *)priceTreatmentScale:(NSInteger)scale {
    double num = [self doubleValue];
    NSString *valuestring = [NSString stringWithFormat:@"%lf", num];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *number = [[NSDecimalNumber decimalNumberWithString:valuestring] decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [number stringValue];
}


/// TODO:保留小数点位数
/// @param scale 小数点位数
- (NSString *)checkZeroScale:(NSInteger)scale {
    NSArray *stringArray = [self numberTypeSplit];
    NSMutableArray *stringList = [NSMutableArray arrayWithCapacity:0];
    for (TypeString *typeString in stringArray) {
        if (typeString.type == StringTypeNumber) {
            [stringList addObject:[typeString.string priceTreatmentScale:scale]];
        }else{
            [stringList addObject:typeString.string];
        }
    }
    return [stringList componentsJoinedByString:@""];
}

@end


@implementation UILabel (Extend)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //set方法替换
        [ChangeSelector exchangeInstanceMethodWithClass:[self class] originalSelector:@selector(setText:) swizzledSelector:@selector(setTheText:)];
    });
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.text = self.text;
}

- (void)setIsCheckZero:(BOOL)isCheckZero{
    objc_setAssociatedObject(self, @selector(isCheckZero), @(isCheckZero), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isCheckZero{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDecimalPointLength:(NSInteger)decimalPointLength{
    objc_setAssociatedObject(self, @selector(decimalPointLength), @(decimalPointLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSInteger)decimalPointLength{
    NSNumber *scale = objc_getAssociatedObject(self, _cmd);
    return scale?[scale integerValue]:2;
}

- (void)setTheText:(NSString *)text{
    NSString *theText = text;
    if (self.isCheckZero) {
        theText = [text checkZeroScale:self.decimalPointLength];
    }
    [self setTheText:theText];
}

@end


@implementation UITextField (Extend)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //设置字符串方法替换
        [ChangeSelector exchangeInstanceMethodWithClass:[self class] originalSelector:@selector(setText:) swizzledSelector:@selector(setTheText:)];
    });
}

- (void)setIsCheckPhone:(BOOL)isCheckPhone{
    if (self.isCheckPhone != isCheckPhone) {
        objc_setAssociatedObject(self, @selector(isCheckPhone), @(isCheckPhone), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (isCheckPhone) {
            [self addTarget:self action:@selector(textDidChanged:) forControlEvents:(UIControlEventEditingChanged)];
        }
    }
}

- (BOOL)isCheckPhone{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsCheckPrice:(BOOL)isCheckPrice{
    if (self.isCheckPrice != isCheckPrice) {
        objc_setAssociatedObject(self, @selector(isCheckPrice), @(isCheckPrice), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (isCheckPrice) {
            [self addTarget:self action:@selector(textDidChanged:) forControlEvents:(UIControlEventEditingChanged)];
            [self addTarget:self action:@selector(textDidEnd:) forControlEvents:(UIControlEventEditingDidEndOnExit)];
//            [self addTarget:self action:@selector(textDidEnd:) forControlEvents:(UIControlEventEditingDidEnd)];
        }
    }
}

- (void)setMaxLength:(NSInteger)maxLength{
    objc_setAssociatedObject(self, @selector(maxLength), @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (maxLength > 0) {
        [self addTarget:self action:@selector(textDidChanged:) forControlEvents:(UIControlEventEditingChanged)];
    }else{
        [self removeTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (NSInteger)maxLength{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (BOOL)isCheckPrice{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDecimalPointLength:(NSInteger)decimalPointLength{
    objc_setAssociatedObject(self, @selector(decimalPointLength), @(decimalPointLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSInteger)decimalPointLength{
    NSNumber *scale = objc_getAssociatedObject(self, _cmd);
    return scale?[scale integerValue]:2;
}


- (void)setTheText:(NSString *)text{
    NSString *theText = text;
    if (self.isCheckPrice) {
        theText = [text checkZeroScale:self.decimalPointLength];
    }
    [self setTheText:theText];
}

#pragma mark - text事件
- (void)textDidChanged:(UITextField *)text{
    if (self.isCheckPrice) {
        NSRange rang = [text.text rangeOfString:@"."];
        if (rang.location != NSNotFound) {
            NSString *subStr = [text.text substringFromIndex:rang.location+1];
            if (subStr.length>self.decimalPointLength) {
                text.text = [text.text substringToIndex:rang.location+self.decimalPointLength+1];
                [self sendOtherTager];
            }
        }
    }else if (self.isCheckPhone){
        if (text.text.length > 11) {
            text.text = [text.text substringToIndex:11];
            [self sendOtherTager];
        }
    }else{
        if (self.maxLength>0) {
            if (text.text.length > self.maxLength) {
                text.text = [text.text substringToIndex:self.maxLength];
                [self sendOtherTager];
            }
        }
    }
}

- (void)sendOtherTager{
    for (id tager in self.allTargets) {
        if (tager != self) {
            NSArray *sels = [self actionsForTarget:tager forControlEvent:UIControlEventEditingChanged];
            for (NSString *selName in sels) {
                SEL sel = NSSelectorFromString(selName);
                if ([tager respondsToSelector:sel]) {
                    [tager performSelector:sel withObject:self afterDelay:0.0];
                }
            }
        }
    }
}

- (void)textDidEnd:(UITextField *)text{
    if (self.isCheckPrice) {
        text.text = [text.text priceTreatmentScale:self.decimalPointLength];
    }
}

@end

@implementation UIColor (Extend)

/// TODO:十六进制颜色
/// @param hex 十六进制数字
/// @param a 透明度
+ (UIColor *)hex:(int32_t)hex a:(CGFloat)a{
    return [UIColor colorWithRed:((hex & 0xFF0000) >> 16)/255.0 green:((hex & 0xFF00) >> 8)/255.0 blue:(hex & 0xFF)/255.0 alpha:a];
}


/// TODO:颜色设置，兼容暗黑模式
/// @param lightColor 普通模式颜色
/// @param darkColor 暗黑模式颜色
+ (UIColor *)colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor{
    if (@available(iOS 13.0, *)) {
        if (darkColor != nil) {
            UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                    return lightColor;
                }else {
                    return darkColor;
                }
            }];
            return color;
        }else{
            return lightColor;
        }
    }else{
        return lightColor;
    }
}

@end
