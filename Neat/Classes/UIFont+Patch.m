//
//  UIFont+Patch.m
//  Pods
//
//  Created by Gao on 4/8/17.
//
//

#import "UIFont+Patch.h"
#import <objc/runtime.h>


@implementation UIFont(Patch)

- (UIFont *)systemDefaultOfSameSize {
    const void *key = @selector(systemDefaultOfSameSize);
    UIFont *saved = objc_getAssociatedObject(self, key);
    if (!saved) {
        saved = [UIFont systemFontOfSize:self.pointSize];
        objc_setAssociatedObject(self, key, saved, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return saved;
}

- (CGFloat)neat_lineHeight {
    return [[self systemDefaultOfSameSize] neat_lineHeight];
}
- (CGFloat)neat_descender {
    return [[self systemDefaultOfSameSize] neat_descender];
}
- (CGFloat)neat_leading {
    return [[self systemDefaultOfSameSize] neat_leading];
}
- (CGFloat)neat_ascender {
    return [[self systemDefaultOfSameSize] neat_ascender];
}
- (CGFloat)neat_capHeight {
    return [[self systemDefaultOfSameSize] neat_capHeight];
}
- (CGFloat)neat_xHeight {
    return [[self systemDefaultOfSameSize] neat_xHeight];
}

static dispatch_once_t onceToken;

+ (void)patchMetrics {
    dispatch_once(&onceToken, ^{
        [self exchangeMethod:@selector(lineHeight) another:@selector(neat_lineHeight)];
        [self exchangeMethod:@selector(descender) another:@selector(neat_descender)];
        [self exchangeMethod:@selector(leading) another:@selector(neat_leading)];
        [self exchangeMethod:@selector(ascender) another:@selector(neat_ascender)];
        [self exchangeMethod:@selector(capHeight) another:@selector(neat_capHeight)];
        [self exchangeMethod:@selector(xHeight) another:@selector(neat_xHeight)];
    });
}

+ (void)exchangeMethod:(SEL)selector another:(SEL)another {
    Class c = [UIFont class];
    Method originalMethod = class_getInstanceMethod(c, selector);
    Method swizzledMethod = class_getInstanceMethod(c, another);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

#if DEBUG

+ (void)unpatch {
    if (!onceToken) {
        return;
    }
    onceToken = 0;
    [self patchMetrics];
    onceToken = 0;
}

#endif
@end
