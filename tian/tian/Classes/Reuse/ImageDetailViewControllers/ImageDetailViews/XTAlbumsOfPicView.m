//
//  XTAlbumsOfPicView.m
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTAlbumsOfPicView.h"
#import "XTAlbumModel.h"
#import "UIImageView+WebCache.h"
@interface XTAlbumsOfPicView ()



@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;




@end


@implementation XTAlbumsOfPicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void)awakeFromNib{
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

-(void)setModel:(XTAlbumModel *)aModel{
    _model = aModel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.cover] placeholderImage:UIIMAGE(@"placeholderImage4.png")];
    
    self.titleLabel.text = _model.title;
    
    self.contentLabel.text = _model.des;
    
    
}

-(void)tapGesture:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(tapAction:)]) {
        [self.delegate tapAction:self.model];
    }
    
}



@end
