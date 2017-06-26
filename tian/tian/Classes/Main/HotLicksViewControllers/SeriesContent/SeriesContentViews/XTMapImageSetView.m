//
//  XTMapImage.m
//  tian
//
//  Created by loong on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTMapImageSetView.h"
#import "XTMapImageSetViewModel.h"
#import "Masonry.h"
#import "XTMapImageView.h"
#import "XTCommonMacro.h"
#import "XTMapImagesView.h"
#import "NSString+TextSize.h"
@interface XTMapImageSetView()

@property(nonatomic,weak) IBOutlet XTMapImagesView *imgSetView;

@property(nonatomic,weak) IBOutlet UILabel *contentLabel;

@property(nonatomic,weak) IBOutlet UILabel *commentNumLabel;

@end



@implementation XTMapImageSetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.contentLabel.preferredMaxLayoutWidth = self.contentLabel.frame.size.width;
    }
    return self;
}
-(void)awakeFromNib{
    self.contentLabel.preferredMaxLayoutWidth = SCREEN_SIZE.width - 52;
}

-(void)setModel:(XTMapImageSetViewModel *)aModel{
    _model = aModel;
    
    NSString *str = _model.content;
    
    self.contentLabel.text = str;
    
    self.imgSetView.arr = _model.albums;

}

-(void)setCommentNum:(NSNumber *)aCommentNum{
    _commentNum = aCommentNum;
    self.commentNumLabel.hidden = ([_commentNum integerValue] == 0) ? YES : NO;
    self.commentNumLabel.text = [NSString stringWithFormat:@"评论(%@)",_commentNum];
}


-(void)setDelegate:(id)aDelegate{
    _delegate = aDelegate;
    self.imgSetView.delegate = _delegate;
}

-(UIImage *)getImageForShare{
    NSArray *subViews = self.imgSetView.subviews;
    
    XTMapImageView *mapImageView = subViews[0];
    
    return mapImageView.image;
}




@end
