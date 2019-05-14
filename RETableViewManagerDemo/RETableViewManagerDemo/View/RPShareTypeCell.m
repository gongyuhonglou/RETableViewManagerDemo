//
//  RPShareTypeCell.m
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "RPShareTypeCell.h"
#import "RPShareCategoryModule.h"
#import "Masonry.h"
#import "RPShareTypeItemCell.h"

@interface RPShareTypeCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSArray *dataSource;
@property(nonatomic,strong) NSMutableArray *selectArr;

// 选中cell的indexPath
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
// 取消选中的cell，防止由于重用，在取消选中的代理方法中没有设置
@property (nonatomic, strong) NSIndexPath *DeselectIndexpath;
@end

static NSString *shareTypeItemCellId = @"shareTypeItemCellId";

@implementation RPShareTypeCell
@synthesize item = _item;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    //默认选中第一个
    self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.selectArr = [NSMutableArray array];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80, 35);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"RPShareTypeItemCell" bundle:nil] forCellWithReuseIdentifier:shareTypeItemCellId];
    [self.contentView addSubview:self.collectionView];
    
    // 设置collectionView的数据
    //    [self setupCollectionViewData];
}

- (void)setItem:(RPShareTypeItem *)item {
    _item = item;
    self.dataSource = _item.datasource;//@[@"互帮互助",@"违章搭建",@"垃圾分类",@"其他"];
    _item.shareCategoryLabel = _item.datasource[0];//默认选中第一个
    [self.collectionView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark 设置collectionView的数据
//- (void)setupCollectionViewData {
//
//    self.dataSource = _item.datasource;//@[@"互帮互助",@"违章搭建",@"垃圾分类",@"其他"];
//
//    [self.collectionView reloadData];
//
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
//    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
//}

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.top.equalTo(self.contentView.mas_top);
    }];
}

#pragma mark - DataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float w = (self.contentView.frame.size.width - 60)/4;
    float h = 35;
    return (CGSize){w,h};
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RPShareTypeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shareTypeItemCellId forIndexPath:indexPath];
    cell.shareTypeStr = self.dataSource[indexPath.row];
    
    if ([self.selectIndexPath isEqual:indexPath]) {
        cell.shareTypeColor = [UIColor hexStringToColor:@"#FFFFFF"];
        [cell setBackgroundColor:[UIColor hexStringToColor:@"#F34949"]];
    } else {
        cell.shareTypeColor = [UIColor hexStringToColor:@"#929699"];
        [cell setBackgroundColor:[UIColor hexStringToColor:@"#F8F8F8"]];
    }
    return cell;
}
//选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndexPath = indexPath;
    RPShareTypeItemCell *cell = (RPShareTypeItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.shareTypeColor = [UIColor hexStringToColor:@"#FFFFFF"];
    [cell setBackgroundColor:[UIColor hexStringToColor:@"#F34949"]];
    _item.shareCategoryLabel = self.dataSource[indexPath.row];
}
//非选中
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.DeselectIndexpath = indexPath;
    RPShareTypeItemCell *cell = (RPShareTypeItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell == nil) { // 如果重用之后拿不到cell,就直接返回
        return;
    }
    cell.shareTypeColor = [UIColor hexStringToColor:@"#929699"];
    [cell setBackgroundColor:[UIColor hexStringToColor:@"#F8F8F8"]];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    RPShareTypeItemCell *shareCell = (RPShareTypeItemCell *)cell;
    if (self.DeselectIndexpath && [self.DeselectIndexpath isEqual:indexPath]) {
        shareCell.shareTypeColor = [UIColor hexStringToColor:@"#929699"];
        [shareCell setBackgroundColor:[UIColor hexStringToColor:@"#F8F8F8"]];
    }
    if ([self.selectIndexPath isEqual:indexPath]) {
        shareCell.shareTypeColor = [UIColor hexStringToColor:@"#FFFFFF"];
        [shareCell setBackgroundColor:[UIColor hexStringToColor:@"#F34949"]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
