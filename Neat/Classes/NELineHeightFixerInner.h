//
//  NELineHeightFixerInner.h
//  Pods
//
//  Created by Gao on 04/04/2017.
//
//

#import "NELineHeightFixer.h"

@interface NELineHeightFixer()

/// If NELineHeightFixer is wrapped by NSLayoutManagerDelegateFixerWrapper(NSProxy),
/// this will tell what the real delegate object is.
@property (nonatomic, weak) id<NSLayoutManagerDelegate> realTarget;

@end
