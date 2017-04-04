//
//  NSLayoutManager+LineHeightFixer.h
//  Pods
//
//  Created by Gao on 3/30/17.
//
//

#import <UIKit/UIKit.h>

#if DEBUG
@interface NSLayoutManager(NELineHeightFixer)

/// One-line method to fix the line height problems.
/// Call before NSlayoutManager's init method.
///
/// This method will swizzle the related methods, making
/// layoutManager's delegate to ethier `NELineHeightFixer`
/// or `NSLayoutManagerDelegateFixerWrapper` automatically.
///
/// NOTE:
///    This method will effect the layoutManager in UITextView,
///    which will led to UNEXCEPT RESULTS. Just use it as a demo.
///    If you cannot reach the layoutManager instance, just hook
///    the specific method and set delegate.
///
+ (void)fixLineHeight;

@end
#endif
