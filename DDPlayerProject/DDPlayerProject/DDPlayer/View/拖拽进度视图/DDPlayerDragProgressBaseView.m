//
//  DDPlayerDragProgressBaseView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/14.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDPlayerDragProgressBaseView.h"
#import <Masonry.h>
#import "DDPlayerTool.h"

@interface DDPlayerDragProgressBaseView()



@end

@implementation DDPlayerDragProgressBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    [self addSubview:self.timeLabel];
    
}

- (void)setProgress:(CGFloat)progress duration:(CGFloat)duration {
    
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColor.whiteColor;
        _timeLabel.font = [UIFont boldSystemFontOfSize:16];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}



@end
