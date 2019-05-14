//
//  RPShareTypeItem.h
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "RETableViewItem.h"

NS_ASSUME_NONNULL_BEGIN

@class RPShareTypeCell;
@interface RPShareTypeItem : RETableViewItem

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSString *shareCategoryLabel;
@end

NS_ASSUME_NONNULL_END
