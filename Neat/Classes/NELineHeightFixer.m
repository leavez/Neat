//
//  NELineHeightFixer.m
//  Neat
//
//  Created by Gao on 3/25/17.
//  Copyright © 2017 leave. All rights reserved.
//

#import "NELineHeightFixer.h"
#import "NELineHeightFixerInner.h"

@implementation NELineHeightFixer

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (BOOL)layoutManager    :(NSLayoutManager *)layoutManager
shouldSetLineFragmentRect:(inout CGRect *)lineFragmentRect
     lineFragmentUsedRect:(inout CGRect *)lineFragmentUsedRect
           baselineOffset:(inout CGFloat *)baselineOffset
          inTextContainer:(NSTextContainer *)textContainer
            forGlyphRange:(NSRange)glyphRange
{

    // --- get info ---
    UIFont *font;
    NSParagraphStyle *style;
    NSArray *attrsList = [self attributesListForGlyphRange:glyphRange layoutManager:layoutManager];
    [self getFont:&font paragraphStyle:&style fromAttibutesList:attrsList];

    if (![font isKindOfClass:[UIFont class]]) {
        return NO;
    }

    UIFont *defaultFont = [self systemDefaultFontForFont:font];


    // --- calculate the rects ---
    CGRect rect = *lineFragmentRect;
    CGRect usedRect = *lineFragmentUsedRect;

    // calculate the right line fragment height
    CGFloat textLineHeight = [self lineHeightForFont:defaultFont paragraphStyle:style];
    CGFloat fixedBaseLineOffset = [self baseLineOffsetForLineHeight:textLineHeight font:defaultFont];

    rect.size.height = textLineHeight;
    // Some font (like emoji) have large lineHeight than the one we calculated. If we set the usedRect
    // to a small line height, it will make the last line to disappear. So here we only adopt the calcuated
    // lineHeight when is larger than the original.
    //
    // This may lead to a unwanted result that textView have extra pading below last line. To solve this
    // problem, you could set maxLineHeight to lineHeight we calculated using ``.
    usedRect.size.height = MAX(textLineHeight, usedRect.size.height);


    /*
     From apple's doc:
     https://developer.apple.com/library/content/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/CustomTextProcessing/CustomTextProcessing.html
     In addition to returning the line fragment rectangle itself, the layout manager returns a rectangle called the used rectangle. This is the portion of the line fragment rectangle that actually contains glyphs or other marks to be drawn. By convention, both rectangles include the line fragment padding and the interline space (which is calculated from the font’s line height metrics and the paragraph’s line spacing parameters). However, the paragraph spacing (before and after) and any space added around the text, such as that caused by center-spaced text, are included only in the line fragment rectangle, and are not included in the used rectangle.
     */

    CGRect strippedRect = rect;
    NSInteger lastIndexOfCurrentRange = glyphRange.location + glyphRange.length - 1;

    // line spacing
    {
        // Althought the doc said usedRect should container lineSpacing,
        // we don't add the lineSpacing to usedRect to avoid the case that
        // last sentance have a extra lineSpacing pading.

        SEL sel = @selector(layoutManager:lineSpacingAfterGlyphAtIndex:withProposedLineFragmentRect:);
        CGFloat lineSpacing = 0;
        if ([self.realTarget respondsToSelector:sel]) {
            lineSpacing = [self.realTarget layoutManager:layoutManager lineSpacingAfterGlyphAtIndex:lastIndexOfCurrentRange withProposedLineFragmentRect:strippedRect];
        } else if (style) {
            lineSpacing = style.lineSpacing;
        }
        rect.size.height += lineSpacing;
    }

    // paragraphSpacing
    {
        SEL sel = @selector(layoutManager:paragraphSpacingBeforeGlyphAtIndex:withProposedLineFragmentRect:);
        BOOL methodImplemented = [layoutManager.delegate respondsToSelector:sel];
        if (style.paragraphSpacing != 0 || methodImplemented ) {
            NSTextStorage *textStorage = layoutManager.textStorage;
            NSRange charaterRange = [layoutManager characterRangeForGlyphRange:NSMakeRange(glyphRange.location + glyphRange.length-1, 1) actualGlyphRange:nil];
            NSAttributedString *s = [textStorage attributedSubstringFromRange:charaterRange];
            if ([s.string isEqualToString:@"\n"]) {

                if (methodImplemented) {
                    CGFloat space = [layoutManager.delegate layoutManager:layoutManager paragraphSpacingAfterGlyphAtIndex:lastIndexOfCurrentRange withProposedLineFragmentRect:strippedRect];
                    rect.size.height += space;
                } else {
                    rect.size.height += style.paragraphSpacing;
                }
            }
        }
    }
    // paragraphSpacing before
    {
        SEL sel = @selector(layoutManager:paragraphSpacingBeforeGlyphAtIndex:withProposedLineFragmentRect:);
        BOOL methodImplemented = [layoutManager.delegate respondsToSelector:sel];

        if (glyphRange.location > 0 && (style.paragraphSpacingBefore > 0 || methodImplemented) )
        {
            NSTextStorage *textStorage = layoutManager.textStorage;
            NSRange lastLineEndRange = NSMakeRange(glyphRange.location-1, 1);
            NSRange charaterRange = [layoutManager characterRangeForGlyphRange:lastLineEndRange actualGlyphRange:nil];
            NSAttributedString *s = [textStorage attributedSubstringFromRange:charaterRange];
            if ([s.string isEqualToString:@"\n"]) {

                CGFloat space = 0;
                if (methodImplemented) {
                    space = [layoutManager.delegate layoutManager:layoutManager paragraphSpacingBeforeGlyphAtIndex:glyphRange.location withProposedLineFragmentRect:strippedRect];
                } else {
                    space = style.paragraphSpacingBefore;
                }
                usedRect.origin.y += space;
                rect.size.height += space;
                fixedBaseLineOffset += space;
            }
        }
    }

    *lineFragmentRect = rect;
    *lineFragmentUsedRect = usedRect;
    *baselineOffset = fixedBaseLineOffset;
    return YES;
}



// Implementing this method with a return value 0 will solve the problem of last line disappearing
// when both maxNumberOfLines and lineSpacing are set, since we didn't include the lineSpacing in
// the lineFragmentUsedRect.
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    return 0;
}

#pragma mark - private

- (CGFloat)lineHeightForFont:(UIFont *)font paragraphStyle:(NSParagraphStyle *)style  {
    CGFloat lineHeight = font.lineHeight;
    if (!style) {
        return lineHeight;
    }
    if (style.lineHeightMultiple > 0) {
        lineHeight *= style.lineHeightMultiple;
    }
    if (style.minimumLineHeight > 0) {
        lineHeight = MAX(style.minimumLineHeight, lineHeight);
    }
    if (style.maximumLineHeight > 0) {
        lineHeight = MIN(style.maximumLineHeight, lineHeight);
    }
    return lineHeight;
}

- (CGFloat)baseLineOffsetForLineHeight:(CGFloat)lineHeight font:(UIFont *)font {
    CGFloat baseLine = lineHeight + font.descender;
    return baseLine;
}

/// get system default font of size
- (UIFont *)systemDefaultFontForFont:(UIFont *)font {
    return [UIFont systemFontOfSize:font.pointSize];
}


- (NSArray<NSDictionary *> *)attributesListForGlyphRange:(NSRange)glyphRange layoutManager:(NSLayoutManager *)layoutManager {

    // exclude the line break. System doesn't calucate the line rect with it.
    if (glyphRange.length > 1) {
        NSGlyphProperty property = [layoutManager propertyForGlyphAtIndex:glyphRange.location + glyphRange.length - 1];
        if (property & NSGlyphPropertyControlCharacter) {
            glyphRange = NSMakeRange(glyphRange.location, glyphRange.length - 1);
        }
    }

    
    NSTextStorage *textStorage = layoutManager.textStorage;
    NSRange targetRange = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:nil];
    NSMutableArray *dicts = [NSMutableArray arrayWithCapacity:2];

    NSInteger last = -1;
    NSRange effectRange = NSMakeRange(targetRange.location, 0);

    while (effectRange.location + effectRange.length < targetRange.location + targetRange.length) {
        NSInteger current = effectRange.location + effectRange.length;
        // if effectRange didn't advanced, we manuly add 1 to avoid infinate loop.
        if (current <= last) {
            current += 1;
        }
        NSDictionary *attributes = [textStorage attributesAtIndex:current effectiveRange:&effectRange];
        if (attributes) {
            [dicts addObject:attributes];
        }
        last = current;
    }

    return dicts;
}

- (void)getFont:(UIFont **)returnFont paragraphStyle:(NSParagraphStyle **)returnStyle fromAttibutesList:(NSArray<NSDictionary *> *)attributesList {

    if (attributesList.count == 0) {
        return;
    }

    UIFont *findedFont = nil;
    NSParagraphStyle *findedStyle = nil;
    CGFloat lastHeight = -CGFLOAT_MAX;

    // find the attributes with max line height
    for (NSInteger i = 0; i < attributesList.count; i++) {
        NSDictionary *attrs = attributesList[i];

        NSParagraphStyle *style = attrs[NSParagraphStyleAttributeName];
        UIFont *font = attrs[NSFontAttributeName];

        if ([font isKindOfClass:[UIFont class]] &&
            (!style || [style isKindOfClass:[NSParagraphStyle class]]) ) {

            CGFloat height = [self lineHeightForFont:font paragraphStyle:style];
            if (height > lastHeight) {
                lastHeight = height;
                findedFont = font;
                findedStyle = style;
            }
        }
    }

    *returnFont = findedFont;
    *returnStyle = findedStyle;
}

@end
