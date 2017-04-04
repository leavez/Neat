//
//  UILayoutManagerDelegateFixer.m
//  Pods
//
//  Created by Gao on 3/30/17.
//
//

#import "NSLayoutManagerDelegateFixerWrapper.h"
#import <objc/runtime.h>
#import "NELineHeightFixer.h"
#import "NELineHeightFixerInner.h"

@interface NSLayoutManagerDelegateFixerWrapper()
@property (nonatomic, weak) NSObject<NSLayoutManagerDelegate> *target;
@property (nonatomic) NELineHeightFixer *fixer;
@end

@implementation NSLayoutManagerDelegateFixerWrapper

- (instancetype)initWithRealDelegate:(id<NSLayoutManagerDelegate>)realDelegate {
    self.target = realDelegate;
    [self attachSelfToObject:realDelegate];
    self.fixer = [[NELineHeightFixer alloc] init];
    self.fixer.realTarget = realDelegate;
    return self;
}

- (void)attachSelfToObject:(id)object {
    objc_setAssociatedObject(object, @selector(attachSelfToObject:), self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [self.target methodSignatureForSelector:selector];
}


- (void)forwardInvocation:(NSInvocation *)invocation {

    SEL lineRectSelector = @selector(layoutManager:shouldSetLineFragmentRect:lineFragmentUsedRect:baselineOffset:inTextContainer:forGlyphRange:);
    SEL lineSpacingSelector = @selector(layoutManager:lineSpacingAfterGlyphAtIndex:withProposedLineFragmentRect:);

    if (invocation.selector == @selector(respondsToSelector:)) {
        
        SEL toSelector;
        [invocation getArgument:&toSelector atIndex:2];
        if (toSelector == lineRectSelector || toSelector == lineSpacingSelector) {
            [invocation invokeWithTarget:self.fixer];
            return;
        }

    } else if (invocation.selector == lineRectSelector) {

        // invoke the fixer firstly
        [invocation invokeWithTarget:self.fixer];

        // invoke the target and mix the result
        if ([self.target respondsToSelector:lineRectSelector]) {
            BOOL returnValue;
            [invocation getReturnValue:&returnValue];
            BOOL returnValue2;
            [invocation invokeWithTarget:self.target];
            [invocation getReturnValue:&returnValue2];
            BOOL finalValue = returnValue || returnValue2;
            [invocation setReturnValue:&finalValue];
        }
        return;

    } else if (invocation.selector == lineSpacingSelector) {

        if ([self.target respondsToSelector:lineRectSelector]) {
            [invocation invokeWithTarget:self.target];
        } else {
            [invocation invokeWithTarget:self.fixer];
        }
        return;
    }

    [invocation invokeWithTarget:self.target];
}

@end
