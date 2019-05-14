//
//  RPShareTypeItemCell.h
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RPShareTypeItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *shareTypeItem;
@property (nonatomic, copy) NSString *shareTypeStr;
@property (nonatomic, copy) UIColor *shareTypeColor;

@end

NS_ASSUME_NONNULL_END
