//
//  TextLayer.m
//  TextKit
//
//  Created by Gao on 3/25/17.
//  Copyright © 2017 leave. All rights reserved.
//

#import "TextLayer.h"

@implementation TextLayer


+ (id)defaultValueForKey:(NSString *)key {
    if ([key isEqualToString:@"contentsScale"]) {
        return @([UIScreen mainScreen].scale);
    }
    return [super defaultValueForKey:key];
}

- (void)setRenderer:(TextRenderer *)renderer {
    if (renderer == _renderer) {
        return;
    }
    //TODO: filter the same attributes to avoid re-rendering
    _renderer = renderer;

    self.contents = nil;
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {

    if (self.opaque && self.backgroundColor != NULL) {
        CGRect boundsRect = CGContextGetClipBoundingBox(ctx);
        CGContextSetFillColorWithColor(ctx, self.backgroundColor);
        CGContextFillRect(ctx, boundsRect);
    }

    CGRect boundsRect = CGContextGetClipBoundingBox(ctx);
    [self.renderer drawInContext:ctx bounds:boundsRect];
}

@end

