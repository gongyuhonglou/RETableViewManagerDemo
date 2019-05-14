//
//  RPSharePhotoItemCell.h
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RPSharePhotoItemCell : UICollectionViewCell

/** <#digest#> */
@property (nonatomic, strong) UIImage *photoImage;

/** <#digest#> */
@property (nonatomic, copy) void(^deletePhotoClick)(UIImage *photoImage);

/** <#digest#> */
@property (nonatomic, copy) void(^addPhotoClick)(RPSharePhotoItemCell *uploadImageCell);

/** <#digest#> */
@property (nonatomic, assign) CGFloat uploadProgress;

@end

NS_ASSUME_NONNULL_END
