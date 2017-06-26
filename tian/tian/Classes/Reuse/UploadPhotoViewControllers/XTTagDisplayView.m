//
//  XTTagDisplayView.m
//  tian
//
//  Created by 曹亚云 on 15-6-16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTagDisplayView.h"
#import "YYTAlertView.h"
@interface XTTagDisplayView()

@end

@implementation XTTagDisplayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self tagWriteView];
        [self tagCountLabel];
    }
    return self;
}

- (HKKTagWriteView *)tagWriteView{
    if (!_tagWriteView) {
//        _tagWriteView = [[HKKTagWriteView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_SIZE.width-20, 80) withTagType:XTTagTypeVerticalText];
        _tagWriteView = [[HKKTagWriteView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width-20, 0) withTagType:XTTagTypeVerticalText];
        //_tagWriteView.backgroundColor = [UIColor yellowColor];
        _tagWriteView.tagBackgroundColor = [UIColor clearColor];
        [self addSubview:_tagWriteView];
        
        [_tagWriteView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 5, 20, 5));
        }];
    }
    return _tagWriteView;
}

- (UILabel *)tagCountLabel{
    if (!_tagCountLabel) {
//        _tagCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width-40, 90, 20, 10)];
        _tagCountLabel = [UILabel new];
        _tagCountLabel.text = @"0/5";
        _tagCountLabel.font = [UIFont systemFontOfSize:10];
        _tagCountLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:_tagCountLabel];
        
        [_tagCountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tagWriteView.bottom).offset(@5);
            make.right.equalTo(_tagWriteView);
            make.height.equalTo(@10);
        }];
    }
    return _tagCountLabel;
}

- (void)addTag:(NSString *)tag animated:(BOOL)animated{
    if ([_tagWriteView.tags count] < 5) {
        [_tagWriteView addTagToLast:tag animated:animated];
        _tagCountLabel.text = [NSString stringWithFormat:@"%ld/5",[_tagWriteView.tags count]];
    }else{
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"您最多可以添加5个标签" withCompletionBlock:nil];
    }
}

- (void)addtags:(NSArray *)tagArray{
    [_tagWriteView addTags:tagArray];
}

@end
