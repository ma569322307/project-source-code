//
//  XTMapImage.m
//  tian
//
//  Created by loong on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTMapImageView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "XTMapImageviewModel.h"
@interface XTMapImageView()

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *desLabel;

@end



@implementation XTMapImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(super.mas_top).with.offset(0);
            make.left.equalTo(super.mas_left).with.offset(0);
            make.right.equalTo(super.mas_right).with.offset(0);
            make.bottom.equalTo(super.mas_bottom).with.offset(-22);
        }];
    }
    return _imageView;
}


-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:10];
        _desLabel.textColor = UIColorFromRGB(0x7b7b7b);
        [self addSubview:_desLabel];
        [_desLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).with.offset(0);
            make.left.equalTo(super.mas_left).with.offset(0);
            make.right.equalTo(super.mas_right).with.offset(0);
            make.bottom.equalTo(super.mas_bottom).with.offset(0);
        }];
    }
    return _desLabel;
}

-(void)setModel:(XTMapImageViewModel *)aModel{
    _model = aModel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.cover] placeholderImage:UIIMAGE(@"placeholderImage4.png") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image;
        
        if ([self.delegate respondsToSelector:@selector(imageLoadFinishWithIndex:)]) {
            [self.delegate imageLoadFinishWithIndex:self.tag];
        }
    }];
    self.desLabel.text = _model.title;
}







@end
