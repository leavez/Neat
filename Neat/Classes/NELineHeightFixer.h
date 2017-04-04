//
//  NELineHeightFixer.h
//  Neat
//
//  Created by Gao on 3/25/17.
//  Copyright © 2017 leave. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Here solve the wrong line height problem of TextKit when have a mix 
 layout of multi-languages like Chinese, English and emoji. This will
 have the same appearance with UILabel.

 The cause of wrong line height is from the differeces between fonts.
 For a mix text of Chinese and English with system defalut font, the
 Chinese will use `Pingfang SC` actucly and English with `SF UI`. Line
 heights and baseline offsets are handled manually with the metric of
 system default font.
 */
@interface NELineHeightFixer : NSObject <NSLayoutManagerDelegate>

+ (instancetype)sharedInstance;

/**
 Use this method in the implementation of layout manager delegate.
 This method is thread safe.
 */
- (BOOL)layoutManager    :(NSLayoutManager *)layoutManager
shouldSetLineFragmentRect:(inout CGRect *)lineFragmentRect
     lineFragmentUsedRect:(inout CGRect *)lineFragmentUsedRect
           baselineOffset:(inout CGFloat *)baselineOffset
          inTextContainer:(NSTextContainer *)textContainer
            forGlyphRange:(NSRange)glyphRange;
@end
