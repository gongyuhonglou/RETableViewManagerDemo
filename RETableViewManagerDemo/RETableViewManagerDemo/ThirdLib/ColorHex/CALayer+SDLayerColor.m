//
//  CALayer+SDLayerColor.m
//  ShunDao
//
//  Created by rpweng on 2019/2/18.
//  Copyright © 2019 dingyangyang. All rights reserved.
//

#import "CALayer+SDLayerColor.h"

@implementation CALayer (SDLayerColor)

//在xib和storyboard里修改外框颜色keypath:layer.borderColorFromUIColor
- (void)setBorderColorFromUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
