//
//  RPSharePhotoChooseCell.h
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "RETableViewManager.h"
#import "RPSharePhotoChooseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPSharePhotoChooseCell : RETableViewCell

@property (strong, nonatomic) RPSharePhotoChooseItem *item;
@property (strong, readwrite, nonatomic) UILabel *multilineLabel;
@end

NS_ASSUME_NONNULL_END
