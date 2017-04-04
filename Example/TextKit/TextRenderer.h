//
//  TextRenderer.h
//  TextKit
//
//  Created by Gao on 3/25/17.
//  Copyright © 2017 leave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextRenderer : NSObject
@property (nonatomic) NSLayoutManager *layoutManager;
@property (nonatomic) NSTextStorage *textStorage;
@property (nonatomic, readonly) NSTextContainer *textContainer;

- (instancetype)initWithTextStorage:(NSTextStorage *)textStorage;
- (void)drawInContext:(CGContextRef)context bounds:(CGRect)bounds;
@end
