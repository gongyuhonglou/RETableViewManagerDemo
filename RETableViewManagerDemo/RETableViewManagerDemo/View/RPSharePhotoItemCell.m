//
//  RPSharePhotoItemCell.m
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "RPSharePhotoItemCell.h"

@interface RPSharePhotoItemCell()

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation RPSharePhotoItemCell

- (void)setupUIOnce
{
    self.addBtn.hidden = self.imgView.hidden = self.deleteBtn.hidden = YES;
    self.addBtn.hidden = NO;
    
}
- (IBAction)deleteClick:(UIButton *)sender {
    
    kWeakSelf(self);
    !self.deletePhotoClick ?: self.deletePhotoClick(weakself.photoImage);
}

- (IBAction)addClick:(UIButton *)sender {
    kWeakSelf(self);
    !self.addPhotoClick ?: self.addPhotoClick(weakself);
}

- (void)setPhotoImage:(UIImage *)photoImage {
    _photoImage = photoImage;
    
    if (photoImage) {
        self.addBtn.hidden = self.imgView.hidden = self.deleteBtn.hidden = NO;
        self.addBtn.hidden = YES;
    }else {
        self.addBtn.hidden = self.imgView.hidden = self.deleteBtn.hidden = YES;
        self.addBtn.hidden = NO;
    }
    self.imgView.image = photoImage;
}

//- (void)setUploadProgress:(CGFloat)uploadProgress {
//    _uploadProgress = uploadProgress;
//    [self.ringView setProgress:uploadProgress animated:YES];
//    self.ringView.hidden = (uploadProgress == 0 || uploadProgress >= 1);
//}

//- (M13ProgressViewRing *)ringView
//{
//    if(!_ringView)
//    {
//        M13ProgressViewRing *ringView = [[M13ProgressViewRing alloc] init];
//        [self.contentView addSubview:ringView];
//        _ringView = ringView;
//
//        ringView.backgroundRingWidth = 5;
//        ringView.progressRingWidth = 10;
//        ringView.showPercentage = YES;
//        ringView.primaryColor = [UIColor greenColor];
//        ringView.secondaryColor=  [UIColor redColor];
//        ringView.hidden = YES;
//
//        [ringView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.edges.inset(10);
//        }];
//    }
//    return _ringView;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    [self.contentView bringSubviewToFront:_ringView];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUIOnce];
}
@end

