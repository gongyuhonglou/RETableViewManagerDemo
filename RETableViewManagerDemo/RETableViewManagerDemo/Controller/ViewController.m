//
//  ViewController.m
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "ViewController.h"
#import "RPInputView.h"
#import <Masonry/Masonry.h>
#import "RETableViewManager.h"
#import "RPSharePhotoChooseItem.h"
#import "RPShareTypeItem.h"
#import "NSObject+UserDefined.h"

static CGFloat textFieldH = 48;
@interface ViewController ()<UITextViewDelegate,RETableViewManagerDelegate>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) RPInputView *contentTextView;
@property (nonatomic, strong) UIView *publishCommentView;

@property (strong, nonatomic) RETableViewManager *manager;
@property (strong, nonatomic) RPSharePhotoChooseItem *photoChooseItem;
@property (strong, nonatomic) RPShareTypeItem *shareTypeItem;
@property (nonatomic, strong) UITableView *tableView;;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation ViewController
- (void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_contentTextView resignFirstResponder];
//    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发现事件";
    
    self.view.backgroundColor = [UIColor colorWithRed:(242)/255.0 green:(242)/255.0 blue:(242)/255.0 alpha:(1)];
    [self onInitData];
    
    [self requestCategoryData];
}

-(void)onInitData {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+10, kScreen_width, 150)];
    headView.backgroundColor = [UIColor whiteColor];
    //    self.headView = headView;
    //    [self.view addSubview:self.headView];
    
    _contentTextView=[[RPInputView alloc] initWithFrame:CGRectMake(10, 0, kScreen_width-20, 150)];
    _contentTextView.layoutManager.allowsNonContiguousLayout = NO;
    _contentTextView.delegate = self;
    _contentTextView.placeholder = @"这一刻发现的事件...";
    _contentTextView.font = [UIFont systemFontOfSize:16];
    //    _contentTextView.textColor = [UIColor colorWithHexString:@"#323232"];
    _contentTextView.backgroundColor = [UIColor clearColor];
    _contentTextView.maxNumberOfLines = 6;
    _contentTextView.yz_textHeightChangeBlock = ^(BOOL isDelFlag,CGFloat textHeight){ };
    [headView addSubview:_contentTextView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    //    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = headView;
    [self.view addSubview:self.tableView];
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"RPSharePhotoChooseItem"] = @"RPSharePhotoChooseCell";
    self.manager[@"RPShareTypeItem"] = @"RPShareTypeCell";
    
    [self addPhotoChoose];
    [self addCollectionView];
    [self setupFooterView];
    
    _publishCommentView = [[UIView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height-textFieldH+__MainStatusBarHeight, __MainScreen_Width, textFieldH)];
    _publishCommentView.hidden = YES;
    _publishCommentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_publishCommentView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 0.5)];
    lineView.backgroundColor = [UIColor hexStringToColor:@"#e5e5e5"];
    [_publishCommentView addSubview:lineView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    closeButton.backgroundColor = [UIColor clearColor];
    closeButton.frame = CGRectMake(__MainScreen_Width-13-40, 9, 40, 30);
    [closeButton addTarget:self action:@selector(closeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_publishCommentView addSubview:closeButton];
    [self.view bringSubviewToFront:_publishCommentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 请求数据
-(void)requestCategoryData {
    
}

- (RETableViewSection *)addPhotoChoose
{
    //    __typeof (&*self) __weak weakSelf = self;
    RETableViewSection *section = [RETableViewSection section];
    section.headerHeight = 0.1;
    section.footerHeight = 0.1;
    [self.manager addSection:section];
    
    self.photoChooseItem = [RPSharePhotoChooseItem item];
    self.photoChooseItem.tabbarHidden = YES;
    self.photoChooseItem.cellHeight = 100;
    [section addItem:self.photoChooseItem];
    
    return section;
}

- (RETableViewSection *)addCollectionView
{
    //    __typeof (&*self) __weak weakSelf = self;
    
    
    RETableViewSection *section = [RETableViewSection section];
    section.headerHeight = 10;
    section.footerHeight = 0.1;
    [self.manager addSection:section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"选择事件类型" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:NO];
    }];
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
    buttonItem.accessoryView = accessoryView;
    buttonItem.textAlignment = NSTextAlignmentLeft;
    buttonItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:buttonItem];
    
    self.shareTypeItem = [RPShareTypeItem item];
    self.shareTypeItem.cellHeight = 150;
    self.shareTypeItem.datasource = [NSMutableArray arrayWithObjects:@"互帮互助",@"违章搭建",@"垃圾分类",@"关爱老人",@"其他",nil];//self.datasource;
    [section addItem:self.shareTypeItem];
    
    return section;
}

- (void)setupFooterView{
    UIView *footerView = [[UIView alloc] init];
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *updateProblembtn = [[UIButton alloc] init];
    [updateProblembtn setTitle:@"确认" forState:UIControlStateNormal];
    [updateProblembtn addTarget:self action:@selector(updateProblem) forControlEvents:UIControlEventTouchUpInside];
    updateProblembtn.backgroundColor = [UIColor redColor];
    [footerView addSubview:updateProblembtn];
    
    [updateProblembtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footerView.mas_centerY);
        make.left.equalTo(footerView.mas_left).with.offset(20);
        make.right.equalTo(footerView.mas_right).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    
}

#pragma mark -  调整尺寸的相关方法
//键盘的一些事件
- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];// 获取键盘弹出时长
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    if (rect.origin.y != screenH) {//要显示键盘
        _publishCommentView.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            self.publishCommentView.frame = CGRectMake(self.publishCommentView.frame.origin.x, __MainScreen_Height-self.publishCommentView.frame.size.height+__MainStatusBarHeight-rect.size.height, self.publishCommentView.frame.size.width, self.publishCommentView.frame.size.height);
        }];
    }else{//要关闭键盘
        _publishCommentView.hidden = YES;
        [UIView animateWithDuration:duration animations:^{
            self.publishCommentView.frame = CGRectMake(self.publishCommentView.frame.origin.x, __MainScreen_Height-self.publishCommentView.frame.size.height+__MainStatusBarHeight, self.publishCommentView.frame.size.width, self.publishCommentView.frame.size.height);
        }];
    }
}
//关闭键盘按钮
-(void)closeButtonPress:(id)sender{
    [_contentTextView resignFirstResponder];
}

#pragma mark -- 确认提交发现事件
- (void)updateProblem {
    if (_contentTextView.text.length == 0) {
        [MBProgressHUD showText:@"请填写发现事件"];
        return;
    }
    if (self.photoChooseItem.selectedImages.count == 0) {
        [MBProgressHUD showText:@"请添加图片"];
        return;
    }
        
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:_contentTextView.text forKey:@"contentText"];
    [paramsDic setObject:self.shareTypeItem.shareCategoryLabel forKey:@"shareCategory"];
    [paramsDic setObject:self.photoChooseItem.selectedImages forKey:@"file"];

}

@end
