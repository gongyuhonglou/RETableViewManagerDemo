//
//  RPSharePhotoChooseItem.m
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "RPSharePhotoChooseItem.h"
#import "JXTAlertController.h"
#import "UIViewController+ESSeparatorInset.h"
static const NSInteger maxPhotoCount = 3;

@interface RPSharePhotoChooseItem()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>
@end
@implementation RPSharePhotoChooseItem
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        //        if (iOS7Later) {
        //            _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        //        }
        //        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        self.selectedAccest = [NSMutableArray array];
        self.selectedImages = [NSMutableArray array];
        if (self.maxImageCount == 0) {
            self.maxImageCount = maxPhotoCount;
        }
        kWeakSelf(self);
        self.addPhotoClick = ^(RPSharePhotoChooseCell *photoChooseCell) {
            NSLog(@"添加照片");
            if (weakself.selectedImages.count >= self.maxImageCount) {
                [MBProgressHUD showText:[NSString stringWithFormat:@"最多上传%ld张图片",weakself.maxImageCount]];
                
            }else {
                [weakself alertAction];
            }
        };
        self.deletePhotoClick = ^(UIImage *photoImage, NSIndexPath *indexPath) {
            NSLog(@"删除照片");
            [weakself.selectedAccest removeObjectAtIndex:indexPath.item];
            //            [weakself.selectedImages removeObject:photoImage];
            [[weakself mutableArrayValueForKey:@"selectedImages"] removeObject:photoImage];
            
            //            [weakself.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            //            [weakself.collectionView reloadData];
        };
    }
    return self;
}

- (void)alertAction
{
    
    
    [UIAlertController mj_showActionSheetWithTitle:@"图片拍摄时，请选择合理角度，确保设备整体完整清晰显示"
                                           message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                                               alertMaker.addActionDefaultTitle(@"选择相册").addActionDefaultTitle(@"照相").addActionCancelTitle(@"取消");
                                           } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                                               if (buttonIndex == 0) {
                                                   [self choosePhoto];
                                               }else if (buttonIndex == 1) {
                                                   [self takePhoto];
                                               }
                                           }];
}

- (void)choosePhoto
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImageCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    if (self.maxImageCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = self.selectedAccest; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // imagePickerVc.photoWidth = 1000;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // if (iOS7Later) {
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // }
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = kScreen_width - 2 * left;
    NSInteger top = (kScreen_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    imagePickerVc.isStatusBarDefault = NO;
#pragma mark - 到这里为止
    kWeakSelf(self);
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        weakself.selectedImages = [NSMutableArray arrayWithArray:photos];
        weakself.selectedAccest = [NSMutableArray arrayWithArray:assets];
        
        //        [weakself.collectionView reloadData];
        
    }];
    
    [[UIViewController getCurrentVC] presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (void)takePhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        
        [UIAlertController mj_showAlertWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            
            alertMaker.addActionDestructiveTitle(@"取消").addActionDefaultTitle(@"确认");
            
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            
            if (buttonIndex == 1) {
                
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                } else {
                    // Fallback on earlier versions
                }
            }
            
        }];
        
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            [UIAlertController mj_showAlertWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                
                alertMaker.addActionDestructiveTitle(@"取消").addActionDefaultTitle(@"确认");
                
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                
                if (buttonIndex == 1) {
                    
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
            }];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

static UIViewController * extracted() {
    return [UIViewController getCurrentVC];
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *loactions) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (loactions.count != 0) {
            strongSelf.location = loactions.firstObject;
        }
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    //    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
    //        __strong typeof(weakSelf) strongSelf = weakSelf;
    //        strongSelf.location = location;
    //    } failureBlock:^(NSError *error) {
    //        __strong typeof(weakSelf) strongSelf = weakSelf;
    //        strongSelf.location = nil;
    //    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
#warning 错误
        UIViewController *currentVc = [UIViewController getCurrentVC];
        if (!currentVc) {
            return;
        }
        //        extracted()
        [currentVc presentViewController:self.imagePickerVc animated:YES completion:nil];
        //        if (!self.tabbarHidden) {
        //            [UIViewController getCurrentVC].tabBarController.tabBar.hidden = YES;
        //        }
        
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    if (!self.tabbarHidden) {
    //        [UIViewController getCurrentVC].tabBarController.tabBar.hidden = NO;
    //    }
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        //                        if (NO) { // 允许裁剪,去裁剪
                        //                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                        //                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                        //                            }];
                        //                            imagePicker.needCircleCrop = NO;
                        //                            imagePicker.circleCropRadius = 100;
                        //                            [[UIViewController getCurrentVC] presentViewController:imagePicker animated:YES completion:nil];
                        //                        } else {
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        //                        }
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [self.selectedAccest addObject:asset];
    
    [[self mutableArrayValueForKey:@"selectedImages"] addObject:image];
    //    [self.selectedImages addObject:image];
    //    [self.collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}


@end
