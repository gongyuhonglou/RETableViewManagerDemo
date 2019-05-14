//
//  RPSharePhotoChooseItem.h
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "RETableViewItem.h"
#import "TZImagePickerController.h"
#import <AVFoundation/AVFoundation.h>
#import "TZImageManager.h"
#import "TZLocationManager.h"

NS_ASSUME_NONNULL_BEGIN

@class RPSharePhotoChooseCell;
@interface RPSharePhotoChooseItem : RETableViewItem

/** 照片数组 */
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedImages;

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<PHAsset *> *selectedAccest;

/** <#digest#> */
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, assign) NSInteger maxImageCount;
/** 删除照片 */
@property (nonatomic, copy) void(^deletePhotoClick)(UIImage *photoImage,NSIndexPath *indexPath);

/** 添加照片 */
@property (nonatomic, copy) void(^addPhotoClick)(RPSharePhotoChooseCell *photoChooseCell);

@property (nonatomic ,assign)BOOL tabbarHidden;

@end


NS_ASSUME_NONNULL_END
