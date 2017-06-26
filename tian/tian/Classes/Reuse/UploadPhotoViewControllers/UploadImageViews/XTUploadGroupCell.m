//
//  XTUploadGroupCell.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUploadGroupCell.h"
#import "XTUploadGroupModel.h"
#import "XTSingleSelectionController.h"
#define kSPUserResizableViewGlobalInset 5.0
#define kSPUserResizableViewDefaultMinWidth 48.0
#define kSPUserResizableViewDefaultMinHeight 48.0
#define kSPUserResizableViewInteractiveBorderSize 10.0
@interface XTUploadGroupCell()
// imageView
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation XTUploadGroupCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        self.imageView = imageView;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(2, 2, 2, 2));
        }];
        imageView.layer.cornerRadius = kBigSize * 0.5;
        imageView.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.width * 0.5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = kBackColor;
    }
    return self;
}

// 根据模型获取信息
-(void)setGroup:(XTUploadGroupModel *)group{
    _group = group;
    // 根据模型名称获取图片
    self.imageView.image = [UIImage imageNamed:group.smallName];
}


-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 5.0);
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
