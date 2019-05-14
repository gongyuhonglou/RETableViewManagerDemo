//
//  RPShareTypeCell.h
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "RETableViewManager.h"
#import "RPShareTypeItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPShareTypeCell : RETableViewCell

@property (strong, nonatomic) RPShareTypeItem *item;

@property (nonatomic, strong) NSArray *array_Module;

@end

NS_ASSUME_NONNULL_END
