//
//  TextView.h
//  TextKit
//
//  Created by Gao on 3/25/17.
//  Copyright © 2017 leave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextRenderer.h"

@interface TextView : UIView

@property (nonatomic) TextRenderer *renderer;

@property (nonatomic) CGFloat preferredMaxLayoutWidth;

@end
