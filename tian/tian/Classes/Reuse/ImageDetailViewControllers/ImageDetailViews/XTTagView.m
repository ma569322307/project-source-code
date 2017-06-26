//
//  XTTagView.m
//  tian
//
//  Created by loong on 15/7/9.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTTagView.h"
#import "XTTagInfo.h"

@interface XTTagView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end


@implementation XTTagView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(void)setContent:(NSString *)aContent{
//    _content = aContent;
//    self.backgroundColor = [UIColor clearColor];
//    self.contentLabel.text = _content;
////    self.frame = CGRectMake(0, 0, CGRectGetMaxX(self.contentLabel.frame) + 6, CGRectGetHeight(self.frame));
//    //self.width = CGRectGetMaxX(self.contentLabel.frame) + 6;
//}


-(void)setTagInfo:(XTTagInfo *)aTagInfo{
    _tagInfo = aTagInfo;
    
    if (_tagInfo.tagType == XTTagArtist) {
        self.imageView.image = UIIMAGE(@"tag_artist.png");
    }else{
        self.imageView.image = UIIMAGE(@"tag_key.png");
    }
    self.contentLabel.text = _tagInfo.tag;
}

@end
