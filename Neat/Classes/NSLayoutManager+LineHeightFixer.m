//
//  NSLayoutManager+LineHeightFixer.m
//  Pods
//
//  Created by Gao on 3/30/17.
//
//

#import "NSLayoutManager+LineHeightFixer.h"
#import <objc/runtime.h>
#import "NSLayoutManagerDelegateFixerWrapper.h"
#import "NELineHeightFixer.h"

#if DEBUG

@implementation NSLayoutManager (NELineHeightFixer)

- (instancetype)init_leLineFixer {
    NSLayoutManager *instance = [self init_leLineFixer];
    instance.delegate = [NELineHeightFixer sharedInstance];
    return instance;
}

- (void)setDelegate_leLineFixer:(id<NSLayoutManagerDelegate>)delegate {
    if ([delegate isKindOfClass:[NELineHeightFixer class]]
        || [delegate isKindOfClass:[NSLayoutManagerDelegateFixerWrapper class]]
        ) {
        [self setDelegate_leLineFixer:delegate];
    } else {
        NSLayoutManagerDelegateFixerWrapper *wrapper = [[NSLayoutManagerDelegateFixerWrapper alloc] initWithRealDelegate:delegate];
        [self setDelegate_leLineFixer:wrapper];
    }
}

+ (void)fixLineHeight {
    {
        SEL originalSelector = @selector(init);
        SEL swizzledSelector = @selector(init_leLineFixer);
        Method originalMethod = class_getInstanceMethod([NSLayoutManager class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([NSLayoutManager class], swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    {
        SEL originalSelector = @selector(setDelegate:);
        SEL swizzledSelector = @selector(setDelegate_leLineFixer:);
        Method originalMethod = class_getInstanceMethod([NSLayoutManager class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([NSLayoutManager class], swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }

}


@end

#endif
