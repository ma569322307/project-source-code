//
//  XTLickGodHeaderView.m
//  tian
//
//  Created by cc on 15/6/3.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "XTLickGodHeaderView.h"
#import "XTCommonMacro.h"
#define ViewSpace 16
@implementation XTLickGodHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initLickGodViewWith:(NSArray *)objc
{
    self = [super init];
    if (self) {
        self.theViewHeight = 0;
        self.dataArray = objc;
        if (self.dataArray.count>=9) {
            [self addSubViews];
        }
        
    }
    return self;
}

- (void)addSubViews
{
    
    CGFloat myTopicBtnWidth = (SCREEN_SIZE.width - ViewSpace*2 - 8*3)/4.0f;
    CGFloat myTopicBtnHeight = myTopicBtnWidth*184/140;
    
    XTLickGodPropsInfo *godPropsInfo = [self.dataArray firstObject];
    
    UIButton *myTopicBtn;
    SETIMAGEBTN(myTopicBtn, @"", @"");
    
    myTopicBtn.backgroundColor = UIColorFromRGB(0xf8f8f8);
    myTopicBtn.frame = CGRectMake(ViewSpace, ViewSpace, myTopicBtnWidth, myTopicBtnHeight);
    myTopicBtn.tag = 500;
    [myTopicBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:myTopicBtn];
    
    UIImageView *myTopicLogoImageV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, myTopicBtnWidth - 16, myTopicBtnWidth - 16)];
    CHANGETOFILLET(myTopicLogoImageV);
    [myTopicLogoImageV an_setImageWithURL:godPropsInfo.imgUrl placeholderImage:nil];
    [myTopicBtn addSubview:myTopicLogoImageV];
    
    [myTopicBtn setTitleColor:UIColorFromRGB(0x5d5d5d) forState:UIControlStateNormal];
    [myTopicBtn setTitle:godPropsInfo.title forState:UIControlStateNormal];
    myTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(myTopicBtnWidth-8, 0, 0, 0);
    myTopicBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    CGFloat rankBtnWidth = myTopicBtnWidth;
    CGFloat rankBtnHeight = (myTopicBtnHeight - 8)/2.0f;
    
    for (int i=0; i<2; i++) {
        for (int j=0; j<3; j++) {
            XTLickGodPropsInfo *tempGodPropsInfo = [self.dataArray objectAtIndex:i*3+j+1];
            UIButton *rankBtn ;
            SETIMAGEBTN(rankBtn, @"", @"");
            rankBtn.backgroundColor = UIColorFromRGB(0xf8f8f8);
            rankBtn.frame = CGRectMake(ViewSpace +myTopicBtnWidth + 8 +j*(rankBtnWidth+8), ViewSpace +i*(rankBtnHeight+8), rankBtnWidth, rankBtnHeight);
            rankBtn.tag = 500+1+i*3+j;
            [rankBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:rankBtn];
            UIImageView *rankBtnLeftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, rankBtnHeight-12, rankBtnHeight-12)];
            CHANGETOFILLET(rankBtnLeftImageV);
            [rankBtnLeftImageV an_setImageWithURL:tempGodPropsInfo.imgUrl placeholderImage:nil];
            [rankBtn addSubview:rankBtnLeftImageV];
            

            UILabel *rankBtnlabel = [[UILabel alloc]initWithFrame:CGRectMake(rankBtnLeftImageV.frame.size.width+6, 0, rankBtnWidth - rankBtnLeftImageV.frame.size.width - 6-3, rankBtnHeight)];
            rankBtnlabel.text = tempGodPropsInfo.title;
            rankBtnlabel.textAlignment = NSTextAlignmentCenter;
            rankBtnlabel.contentMode = UIViewContentModeCenter;
            rankBtnlabel.font = [UIFont systemFontOfSize:11];
            rankBtnlabel.textColor = UIColorFromRGB(0x5d5d5d);
            [rankBtn addSubview:rankBtnlabel];
            
            
        }
    }
    
    for (int i=0; i<2; i++) {
        
        XTLickGodPropsInfo *tempGodPropsInfo = [self.dataArray objectAtIndex:i + 7];
        CGFloat btnWidth = (SCREEN_SIZE.width-2*ViewSpace-8)/2.0f;
        UIButton *Btn ;
        SETIMAGEBTN(Btn, @"", @"");
        Btn.backgroundColor = UIColorFromRGB(0xf8f8f8);
        Btn.frame = CGRectMake(ViewSpace +i*(btnWidth+8), ViewSpace+myTopicBtnHeight+8, btnWidth, rankBtnHeight);
        Btn.tag = 507+i;
        [Btn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:Btn];
        
        UIImageView *rankBtnLeftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(Btn.frame.size.width/2-rankBtnHeight-5, 6, rankBtnHeight-12, rankBtnHeight-12)];
        CHANGETOFILLET(rankBtnLeftImageV);
        [rankBtnLeftImageV an_setImageWithURL:tempGodPropsInfo.imgUrl placeholderImage:nil];
        [Btn addSubview:rankBtnLeftImageV];
        

        UILabel *rankBtnlabel = [[UILabel alloc]initWithFrame:CGRectMake(rankBtnLeftImageV.frame.origin.x+ rankBtnLeftImageV.frame.size.width+6, 0, rankBtnWidth*2 - rankBtnLeftImageV.frame.size.width - 6*2, rankBtnHeight)];
        rankBtnlabel.text = tempGodPropsInfo.title;
        rankBtnlabel.contentMode = UIViewContentModeCenter;
        rankBtnlabel.font = [UIFont systemFontOfSize:12];
        rankBtnlabel.textColor = UIColorFromRGB(0x5d5d5d);
        [Btn addSubview:rankBtnlabel];
        
        
    }
    
    self.theViewHeight = ViewSpace + myTopicBtnHeight + 8 + rankBtnHeight + ViewSpace;
 
    self.frame = CGRectMake(0, 0, SCREEN_SIZE.width, self.theViewHeight-15);
    
}
- (void)clickBtnAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickGodBtn:)]) {
        [self.delegate clickGodBtn:sender];
    }
}
@end
