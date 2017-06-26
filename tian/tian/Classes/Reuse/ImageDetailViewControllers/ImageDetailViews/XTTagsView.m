//
//  XTTagsView.m
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTagsView.h"
#import "XTTagView.h"

@interface XTTagsView()

@property(nonatomic,weak)IBOutlet UIScrollView *scrollview;

@end



@implementation XTTagsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setTags:(NSArray *)aTags{
    for (UIView *view in self.scrollview.subviews) {
        [view removeFromSuperview];
    }
    _tags = aTags;
    
    CGFloat x = 5;
    NSLog(@"self.scrollView.frame ==== %@",NSStringFromCGRect(self.scrollview.frame));
    
    for (int i = 0; i < _tags.count; i++) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XTTagView" owner:self options:nil];
        XTTagView *tagView = nib[0];
        tagView.tag = i;
        tagView.tagInfo = _tags[i];
        CGSize fittingSize = [tagView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        //tagView.frame = CGRectMake(x, 0, fittingSize.width, fittingSize.height);
        
        [self.scrollview addSubview:tagView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [tagView addGestureRecognizer:tap];
        
        [tagView updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(x);
            make.top.offset(0);
            make.bottom.offset(0);
            make.width.equalTo(fittingSize.width);
            make.height.equalTo(fittingSize.height);
            if (i == _tags.count - 1) {
                make.right.offset(0);
            }
        }];
//        tagView.frame = CGRectMake(x, 0, CGRectGetWidth(tagView.frame), CGRectGetHeight(self.frame));
        [tagView layoutIfNeeded];
        x = CGRectGetMaxX(tagView.frame) + 3;
        //NSLog(@"x ==== %f",x);
        self.scrollview.contentSize = CGSizeMake(x, CGRectGetHeight(self.frame));
        NSLog(@"self.scrollView.contentSize ==== %@",NSStringFromCGSize(self.scrollview.contentSize));
    }
}

-(void)tapGesture:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag;
    
    if ([self.delegate respondsToSelector:@selector(tagViewTapActionWith:)]) {
        [self.delegate tagViewTapActionWith:self.tags[index]];
    }
}



@end
