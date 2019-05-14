//
//  RPShareTypeItemCell.m
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "RPShareTypeItemCell.h"

@implementation RPShareTypeItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.backgroundColor = [UIColor hexStringToColor:@"#F8F8F8"];
    self.layer.cornerRadius = self.bounds.size.height/2;
    self.clipsToBounds = YES;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUI];
}

- (void)setShareTypeStr:(NSString *)shareTypeStr {
    _shareTypeStr = shareTypeStr;
    self.shareTypeItem.text = shareTypeStr;
}

- (void)setShareTypeColor:(UIColor *)shareTypeColor {
    _shareTypeColor = shareTypeColor;
    self.shareTypeItem.textColor = shareTypeColor;
}

@end
