//
//  TextLayer.h
//  TextKit
//
//  Created by Gao on 3/25/17.
//  Copyright © 2017 leave. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TextRenderer.h"

@interface TextLayer : CALayer
@property (nonatomic) TextRenderer *renderer;
@end
