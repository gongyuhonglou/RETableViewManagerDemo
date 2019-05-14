//
//  RPSharePhotoChooseCell.m
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "RPSharePhotoChooseCell.h"
#import "Masonry.h"
#import "RPSharePhotoItemCell.h"
#import "UIViewController+ESSeparatorInset.h"
#import "TZPhotoPreviewController.h"
//static const CGFloat kHorizontalMargin = 10.0;
//static const CGFloat kVerticalMargin = 10.0;

@interface RPSharePhotoChooseCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

//@property (strong, readwrite, nonatomic) UILabel *multilineLabel;
@property (strong, readwrite, nonatomic) UICollectionView *collectionView;


//@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedImages;
//@property (nonatomic, strong) NSMutableArray<PHAsset *> *selectedAccest;
@end
static NSString *photoChooseItemCellId = @"photoChooseItemCellId";
@implementation RPSharePhotoChooseCell
@synthesize item = _item;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//+ (CGFloat)heightWithItem:(SDPhotoChooseItem *)item tableViewManager:(RETableViewManager *)tableViewManager
//{
//    CGFloat horizontalMargin = kHorizontalMargin;
//    if (item.section.style.contentViewMargin <= 0)
//        horizontalMargin += 5.0;
//
//    CGFloat width = CGRectGetWidth(tableViewManager.tableView.bounds) - 2.0 * horizontalMargin;
//    return [item.title re_sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(width, INFINITY)].height + 2.0 * kVerticalMargin;
//    return item.cellHeight;
//}

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    //    self.multilineLabel = [[UILabel alloc] init];
    //    //    self.multilineLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    //    self.multilineLabel.font = [UIFont systemFontOfSize:17];
    //    self.multilineLabel.numberOfLines = 0;
    //    self.multilineLabel.backgroundColor = [UIColor clearColor];
    //    [self.contentView addSubview:self.multilineLabel];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(70, 70);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"RPSharePhotoItemCell" bundle:nil] forCellWithReuseIdentifier:photoChooseItemCellId];
    [self.contentView addSubview:self.collectionView];
    
    //    self.backgroundColor = [UIColor grayColor];
    
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //    self.multilineLabel.text = @"图片:";
    //    self.multilineLabel = _item.multilineLabel;
    //    [self.item addObserver:self forKeyPath:@"selectedImages" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //    CGFloat horizontalMargin = kHorizontalMargin;
    //    if (self.section.style.contentViewMargin <= 0)
    //        horizontalMargin += 5.0;
    //
    //    CGRect frame = CGRectMake(0, 0, 60, [SDPhotoChooseCell heightWithItem:self.chooseItem tableViewManager:self.tableViewManager]);
    //    frame = CGRectInset(frame, horizontalMargin, kVerticalMargin);
    //    self.multilineLabel.frame = frame;
    //    [self.multilineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.contentView.mas_left).offset(10);
    //        make.centerY.equalTo(self.contentView.mas_centerY);
    //        make.size.mas_equalTo(CGSizeMake(40, 30));
    //    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.top.equalTo(self.contentView.mas_top);
    }];
}
//-(void)cellDidDisappear{
//    NSLog(@"cellDidDisappear");
//    if (_item != nil) {
//
//        [_item removeObserver:self forKeyPath:@"selectedImages"];
//    }
//    [super cellDidDisappear];
//}

- (void)setItem:(RPSharePhotoChooseItem *)item
{
    if (_item != nil) {
        [_item removeObserver:self forKeyPath:@"selectedImages"];
    }
    
    _item = item;
    
    [_item addObserver:self forKeyPath:@"selectedImages" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)dealloc {
    if (_item != nil) {
        [_item removeObserver:self forKeyPath:@"selectedImages"];
    }
}

#pragma mark - DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.item.selectedImages.count + 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RPSharePhotoItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoChooseItemCellId forIndexPath:indexPath];
    kWeakSelf(self);
    if (indexPath.item == self.item.selectedImages.count) {
        
        cell.photoImage = nil;
        
        cell.addPhotoClick = ^(RPSharePhotoItemCell *uploadImageCell) {
            //            [weakself alertAction];
            !self.item.addPhotoClick ?: self.item.addPhotoClick(weakself);
            
        };
        
        cell.deletePhotoClick = nil;
    }else {
        cell.photoImage = self.item.selectedImages[indexPath.item];
        cell.addPhotoClick = nil;
        cell.deletePhotoClick = ^(UIImage *photoImage) {
            !self.item.deletePhotoClick ?: self.item.deletePhotoClick(photoImage,indexPath);
            
            //            [weakself.selectedAccest removeObjectAtIndex:indexPath.item];
            //            [weakself.selectedImages removeObject:photoImage];
            //            [weakself.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            //            [weakself.collectionView reloadData];
        };
    }
    
    //    cell.backgroundColor = kRandomColor;
    return  cell;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.item.selectedImages.count == indexPath.row) {
        
    }else{
        
        //        }];
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.item.selectedAccest selectedPhotos:self.item.selectedImages index:indexPath.row];
        imagePickerVc.maxImagesCount = self.item.maxImageCount;
        //        imagePickerVc.allowPickingGif = self.allowPickingGifSwitch.isOn;
        //        imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch.isOn;
        //        imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideoSwitch.isOn;
        //        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self.item.selectedImages = [NSMutableArray arrayWithArray:photos];
            self.item.selectedAccest = [NSMutableArray arrayWithArray:assets];
            //            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [_collectionView reloadData];
            //            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        [[UIViewController getCurrentVC] presentViewController:imagePickerVc animated:YES completion:nil];
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath  isEqual: @"selectedImages"]) {
        NSLog(@"%@",change);
        [self.collectionView reloadData];
    }
}

@end
