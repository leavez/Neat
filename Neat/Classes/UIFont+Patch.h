//
//  UIFont+Patch.h
//  Pods
//
//  Created by Gao on 4/8/17.
//
//

#import <UIKit/UIKit.h>

@interface UIFont(Patch)

+ (void)patchMetrics;


#if DEBUG
+ (void)unpatch;
#endif

@end
