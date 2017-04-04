//
//  TextRenderer.m
//  TextKit
//
//  Created by Gao on 3/25/17.
//  Copyright © 2017 leave. All rights reserved.
//

#import "TextRenderer.h"


@implementation TextRenderer

- (instancetype)initWithTextStorage:(NSTextStorage *)textStorage {
    self = [super init];
    if (self) {
        _textStorage = textStorage;
        // set up
        _layoutManager = [[NSLayoutManager alloc] init];
        _layoutManager.textStorage = textStorage;

        NSTextContainer *container = [[NSTextContainer alloc] initWithSize:CGSizeZero];
        [_layoutManager addTextContainer:container];
    }
    return self;
}

- (void)setTextStorage:(NSTextStorage *)textStorage {
    _textStorage = textStorage;
    self.layoutManager.textStorage = textStorage;
}

- (NSTextContainer *)textContainer {
    return self.layoutManager.textContainers.firstObject;
}

- (void)drawInContext:(CGContextRef)context bounds:(CGRect)bounds {
    CGContextSaveGState(context);
    UIGraphicsPushContext(context);

    NSTextContainer *textContainer = self.layoutManager.textContainers.firstObject;
    NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:textContainer];

    [self.layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:bounds.origin];
    [self.layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:bounds.origin];

    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}

@end
