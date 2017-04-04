//
//  TextView.m
//  TextKit
//
//  Created by Gao on 3/25/17.
//  Copyright © 2017 leave. All rights reserved.
//

#import "TextView.h"
#import "TextLayer.h"

@implementation TextView {
    CALayer *usedRectLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentScaleFactor = [UIScreen mainScreen].scale;
        usedRectLayer = [[CALayer alloc] init];
        usedRectLayer.backgroundColor = [UIColor clearColor].CGColor;
        usedRectLayer.borderWidth = 0.5;
        usedRectLayer.borderColor = [UIColor greenColor].CGColor;
        [self.layer addSublayer:usedRectLayer];
    }
    return self;
}

- (void)setRenderer:(TextRenderer *)renderer {
    [self textLayer].renderer = renderer;
    [self invalidateIntrinsicContentSize];
}
- (TextRenderer *)renderer {
    return [self textLayer].renderer;
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
    _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    [self invalidateIntrinsicContentSize];
}

#pragma mark - override

+ (Class)layerClass {
    return [TextLayer class];
}

- (TextLayer *)textLayer {
    return (TextLayer *)self.layer;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    NSTextContainer *container = self.renderer.layoutManager.textContainers.firstObject;
    container.size = self.bounds.size;
    [self.layer setNeedsDisplay];
    usedRectLayer.frame = [[self textLayer].renderer.layoutManager usedRectForTextContainer:[self textLayer].renderer.textContainer];
}




- (CGSize)intrinsicContentSize {

    NSLayoutManager *layoutManager = [self textLayer].renderer.layoutManager;
    NSTextContainer *textContainer = [self textLayer].renderer.textContainer;

    CGSize savedSize = textContainer.size;
    textContainer.size = CGSizeMake(self.preferredMaxLayoutWidth, CGFLOAT_MAX);

    // Force glyph generation and layout.
    [layoutManager ensureLayoutForTextContainer:textContainer];

    CGRect intrinsicContent = [layoutManager usedRectForTextContainer:textContainer];
    textContainer.size = savedSize;
    intrinsicContent.size.width = self.preferredMaxLayoutWidth;
    intrinsicContent.size.height = ceil(intrinsicContent.size.height);
    return intrinsicContent.size;
}



@end



