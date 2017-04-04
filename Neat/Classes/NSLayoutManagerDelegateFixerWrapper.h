//
//  NSLayoutManagerDelegateFixerWrapper.h
//  Pods
//
//  Created by Gao on 3/30/17.
//
//

#import <UIKit/UIKit.h>

/// If you want to set your own delegate to NSLayoutManager,
/// wrapper it with this class.
///
/// It will forword all methods to the real delegate, not only
/// methods in the NSLayoutManagerDelegate. The thing done here
/// is it hooked the `layoutManager:shouldSetLineFragmentRect ...`
/// method, and fix the parameters.
@interface NSLayoutManagerDelegateFixerWrapper: NSProxy <NSLayoutManagerDelegate>

/// real delegate will retain this object.
- (id)initWithRealDelegate:(NSObject<NSLayoutManagerDelegate> *)realDelegate;

@end
