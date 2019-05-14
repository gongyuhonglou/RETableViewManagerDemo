//
//  CALayer+SDLayerColor.h
//  ShunDao
//
//  Created by rpweng on 2019/2/18.
//  Copyright © 2019 dingyangyang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (SDLayerColor)

- (void)setBorderColorFromUIColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
