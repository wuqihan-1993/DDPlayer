//
//  DDInputView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/22.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDTextView.h"

@interface DDTextView()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *placeholderView;
@property (nonatomic, assign) NSInteger textH;
@property (nonatomic, assign) NSInteger maxTextH;

@end

@implementation DDTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(text))];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(text)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    self.delegate = self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeholderView.frame = self.bounds;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length + text.length > 100) {
        return NO;
    }else {
        return YES;
    }
}
#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(text))]) {
        self.placeholderView.hidden = self.text.length > 0;
    }
}

#pragma mark notification
- (void)textDidChange{
    self.placeholderView.hidden = self.text.length > 0;
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    if (_textH != height) {
        self.scrollEnabled = height > _maxTextH && _maxTextH > 0;
        _textH = height;
        if (self.textViewChanged && self.scrollEnabled == NO) {
            self.textViewChanged(self.text,height);
            //            [self.superview layoutIfNeeded];
            //            self.placeholderView.frame = self.bounds;
        }
    }
}

#pragma mark getter

- (UITextView *)placeholderView {
    if (!_placeholderView) {
        UITextView *placeholderView = [[UITextView alloc]initWithFrame:self.bounds];
        _placeholderView = placeholderView;
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font = self.font;
        _placeholderView.textColor = UIColor.lightGrayColor;
        _placeholderView.backgroundColor = UIColor.clearColor;
        [self addSubview:placeholderView];
    }
    return _placeholderView;
}
#pragma mark setter
- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines
{
    _maxNumberOfLines = maxNumberOfLines;
    _maxTextH = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}
- (void)setCornerRadius:(NSUInteger)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderView.textColor = placeholderColor;
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.placeholderView.text = placeholder;
}
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    
    _placeholderFont = placeholderFont;
    
    self.placeholderView.font = placeholderFont;
}


@end
