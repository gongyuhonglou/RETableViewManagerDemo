//
//  RPInputView.m
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "RPInputView.h"
//#import "YZTextAttachment.h"

@interface RPInputView ()

/**
 *  占位文字View: 为什么使用UITextView，这样直接让占位文字View = 当前textView,文字就会重叠显示
 */
@property (nonatomic, weak) UITextView *placeholderView;

/**
 *  文字高度
 */
@property (nonatomic, assign) NSInteger textH;

/**
 *  文字最大高度
 */
@property (nonatomic, assign) NSInteger maxTextH;

@end

@implementation RPInputView

- (UITextView *)placeholderView
{
    if (_placeholderView == nil) {
        UITextView *placeholderView = [[UITextView alloc] init];
        _placeholderView = placeholderView;
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font = self.font;
        _placeholderView.textColor = [UIColor lightGrayColor];
        _placeholderView.backgroundColor = [UIColor clearColor];
        [self addSubview:placeholderView];
    }
    return _placeholderView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines
{
    _maxNumberOfLines = maxNumberOfLines;
    // 计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
    //    _maxTextH = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
    _maxTextH = ceil(self.font.lineHeight * maxNumberOfLines );
}

- (void)setCornerRadius:(NSUInteger)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setYz_textHeightChangeBlock:(void (^)(BOOL, CGFloat))yz_textChangeBlock
{
    _yz_textHeightChangeBlock = yz_textChangeBlock;
    
    [self textDidChange];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderView.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if([self.text isEqualToString:@""]){
        self.placeholderView.hidden = NO;
    }
    self.placeholderView.text = placeholder;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textDidChange];
}
- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self textDidChange];
}


- (void)textDidChange
{
    
    self.font = [UIFont systemFontOfSize:16];
    
    // 占位文字是否显示
    if(self.text.length > 0){
        self.placeholderView.hidden = YES;
    }else{
        self.placeholderView.hidden = NO;
    }
    
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    if(height ==34){
        height = 36;
    }
    if (_textH != height) { // 高度不一样，就改变了高度
        // 最大高度，可以滚动
        self.scrollEnabled = height > _maxTextH && _maxTextH > 0;
        
        BOOL isDelFlag = NO;
        if(_textH > height){//老的大于新的
            isDelFlag = YES;
        }
        
        _textH = height;
        
        if (_yz_textHeightChangeBlock && self.scrollEnabled == NO) {
            
            _yz_textHeightChangeBlock(isDelFlag,height);
            [self.superview layoutIfNeeded];
            self.placeholderView.frame = self.bounds;
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//http://www.jianshu.com/p/ee98f15f0348
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    //(null)
    NSLog(@"[UIPasteboard generalPasteboard].string :   %@,,,,,%@",[UIPasteboard generalPasteboard].string,NSStringFromSelector(action));
    
    NSString *msg = [UIPasteboard generalPasteboard].string;
    if(action == @selector(copy:)){
        return YES;
    }else if (action == @selector(paste:) && nil!= msg)// && [UIPasteboard generalPasteboard].image
        return YES;
    else{
        return [super canPerformAction:action withSender:sender];
    }
}

- (void)copy:(id)sender{
    
    
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    //表情转换为string
    NSLog(@"self.attributedText : %@",self.attributedText);
    NSLog(@"self.text : %@",self.text);
    //    if (objc_getAssociatedObject(self, @"expectedText")) {
    //        NSAttributedString *expectedText = objc_getAssociatedObject(self, @"expectedText");
    //        NSMutableString *strM = [NSMutableString string];
    //        [expectedText enumerateAttributesInRange:NSMakeRange(0, expectedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
    //            NSString *str = nil;
    //            YZTextAttachment *attachment = attrs[@"NSAttachment"];
    //            if (attachment) { // 表情
    //                str = attachment.emotionStr;
    //                [strM appendString:str];
    //            } else { // 文字
    //                str = [expectedText.string substringWithRange:range];
    //                [strM appendString:str];
    //            }
    //        }];
    //
    //        pasteboard.string = strM;
    //    }else{}
    //
    NSAttributedString *selectMsg = [self.attributedText attributedSubstringFromRange:self.selectedRange];
    
    NSMutableString *strM = [NSMutableString string];
    [selectMsg enumerateAttributesInRange:NSMakeRange(0, selectMsg.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *str = nil;
        //            YZTextAttachment *attachment = attrs[@"NSAttachment"];
        //            if (attachment) { // 表情
        //                attachment.bounds = CGRectMake(0, -3, attachment.imageWidth, attachment.imageHeight);
        //                str = attachment.emotionStr;
        //                [strM appendString:str];
        //            } else { // 文字
        str = [selectMsg.string substringWithRange:range];
        [strM appendString:str];
        //            }
    }];
    pasteboard.string = strM;
}
- (void)paste:(id)sender{
    
    
    NSMutableString *strM = [NSMutableString string];
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *str = nil;
        //        YZTextAttachment *attachment = attrs[@"NSAttachment"];
        //        if (attachment) { // 表情
        //            attachment.bounds = CGRectMake(0, -3, attachment.imageWidth, attachment.imageHeight);
        //            str = attachment.emotionStr;
        //            [strM appendString:str];
        //        } else { // 文字
        str = [self.attributedText.string substringWithRange:range];
        [strM appendString:str];
        //        }
    }];
    
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    NSString *copyMsg = pasteboard.string;
    if(nil != copyMsg && ![copyMsg isEqualToString:@""]){
        self.placeholderView.hidden = YES;
        NSString *pStr = copyMsg;
        [strM appendString:pStr];
        //        NSMutableAttributedString *str = [ZXToolsCommentMethod convertEmotionWithStr:strM WithFontSize:16];
        self.scrollEnabled = YES;
        //        self.attributedText = str;
    }
    
    
    //    if (image) {
    //        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    //        textAttachment.image = image;
    //        NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    //
    //    } else {
    //        // Call the normal paste action
    //        [super paste:sender];
    //    }
}

@end

