//
//  XTHotLicksHeaerView.m
//  tian
//
//  Created by 尚毅 杨 on 15/5/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotLicksHeaerView.h"
#import "XTHotLicksInfo.h"
#import "XTCommonMacro.h"
#import "XTHotLicksHeaderCollectionViewCell.h"
#import <UIButton+WebCache.h>
#define ViewSpace 16
static NSString *idenstr = @"collectioniden";
@implementation XTHotLicksHeaerView

- (id)initWithHotLicksInfo:(XTHotLicksInfo *)HLinfo
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 500)];
    if (self) {
        self.hotLicksinfo = HLinfo;
        self.recsCurrentPage = 0;
        self.thehieght = 0;
        [self initViews];
    }
    return self;
}
- (void)initViews
{
    if (self.hotLicksinfo.banner) {
        [self addBannerView];
    }
    if (self.hotLicksinfo.recs.count>0) {
        XTHotLicksRecsInfo *moreRecInfo = [[XTHotLicksRecsInfo alloc]init];
        moreRecInfo.type = @"more";
        moreRecInfo.title = @"往期回顾";
        NSMutableArray *tempRecArray = [NSMutableArray arrayWithArray:self.hotLicksinfo.recs];
        [tempRecArray addObject:moreRecInfo];
        self.hotLicksinfo.recs = [NSArray arrayWithArray:tempRecArray];
        
        [self addRecsView];
    }
    if (self.hotLicksinfo.ranks.count>0) {
        [self addRankView];
    }
    if (self.hotLicksinfo.topics.count>0) {
        [self addTopicsView];
    }
    if (self.hotLicksinfo.hots.count>0) {
        [self addImageLabel];
    }
    
    self.frame = CGRectMake(0, 0, SCREEN_SIZE.width, self.thehieght - 15);
}

- (void)addBannerView
{
    UIButton *bannerBtn;
    SETIMAGEBTN(bannerBtn, nil, nil);
    bannerBtn.backgroundColor = [UIColor grayColor];
    bannerBtn.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.width*155.0f/375);
    
    XTHotLicksBannerInfo *bannerinfo = self.hotLicksinfo.banner;
    
    CLog(@"%@",bannerinfo.cover);
    [bannerBtn sd_setBackgroundImageWithURL:self.hotLicksinfo.banner.cover forState:UIControlStateNormal];
    [bannerBtn addTarget:self action:@selector(clickBannerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bannerBtn];
    
    self.thehieght += CGRectGetHeight(bannerBtn.frame);
    
}
//运营推荐列表
- (void)addRecsView
{
    UIView *recsBgView = [[UIView alloc]init];
    recsBgView.clipsToBounds = NO;
    recsBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:recsBgView];
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(ViewSpace, 0, 100, 24)];
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.textColor = UIColorFromRGB(0x7f7f7f);
    leftLabel.font = [UIFont systemFontOfSize:11];
    leftLabel.text = @"小编推荐:";
    [recsBgView addSubview:leftLabel];
    
    self.pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width - 50 - ViewSpace, 0, 50, 24)];
    self.pageLabel.textColor = UIColorFromRGB(0x7f7f7f);
    self.pageLabel.font = [UIFont systemFontOfSize:10];
    self.pageLabel.textAlignment = NSTextAlignmentRight;
    self.pageLabel.text = [NSString stringWithFormat:@"1/%ld",[self getThePageCount]];
    [recsBgView addSubview:self.pageLabel];
    
    
    UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
   // flowayout.itemSize =CGSizeMake(SCREEN_SIZE.width*104.0f/375, SCREEN_SIZE.width*104.0f/375+18);
    flowayout.itemSize =CGSizeMake((SCREEN_SIZE.width-4*16)/3.0f,(SCREEN_SIZE.width-4*16)/3.0f+18);
    flowayout.sectionInset = UIEdgeInsetsMake(0, 0, 15, 16);
    flowayout.minimumLineSpacing = 16;
    [flowayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(ViewSpace, self.pageLabel.frame.size.height, SCREEN_SIZE.width-ViewSpace, ((SCREEN_SIZE.width-4*16)/3.0f+33)*2) collectionViewLayout:flowayout];
    collectionView.tag = 120;
    collectionView.clipsToBounds = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerNib:[UINib nibWithNibName:@"XTHotLicksHeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:idenstr];
    [recsBgView addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    collectionView.bounces = YES;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    recsBgView.frame = CGRectMake(0, self.thehieght, SCREEN_SIZE.width, collectionView.frame.size.height +24);
    
    self.thehieght +=CGRectGetHeight(recsBgView.frame);
}
//热门话题
- (void)addTopicsView
{
    NSMutableArray *topicsArray = [NSMutableArray arrayWithArray:self.hotLicksinfo.topics];
    if (topicsArray.count==6) {
        [topicsArray removeLastObject];
    }

    XTHotLicksTopicsInfo *moreTopic = [[XTHotLicksTopicsInfo alloc]init];
    moreTopic.title = @"更多";
    [topicsArray addObject:moreTopic];
    
    long lines =topicsArray.count/2.0 + topicsArray.count%2;
//    int xc = topicsArray.count%2;
    
    UILabel *topicsLabel = [[UILabel alloc]initWithFrame:CGRectMake(ViewSpace, self.thehieght, 150, 26)];
    topicsLabel.text = @"热门话题:";
    topicsLabel.textColor = UIColorFromRGB(0x7f7f7f);
    topicsLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:topicsLabel];
    
    CGFloat btnWidth = (SCREEN_SIZE.width-2*ViewSpace - 8)/2.0f;
    CGFloat btnHeight = btnWidth*72/334.0f;
    
    NSString * topicsTitle = @"";
    
    
    
    for (int i=0; i<lines; i++) {
        for (int j = 0; j<2; j++) {

            XTHotLicksTopicsInfo *hotLicksTopicsInfo = [topicsArray objectAtIndex:i*2+j];
            
            if (i*2+j == topicsArray.count-1) {
                topicsTitle = [NSString stringWithFormat:@"%@",hotLicksTopicsInfo.title];
            }else{
                topicsTitle = [NSString stringWithFormat:@"#%@#",hotLicksTopicsInfo.title];
            }
            
            
            UIButton *topicsBtn ;
            SETIMAGEBTN(topicsBtn, @"", @"");
            topicsBtn.backgroundColor = UIColorFromRGB(0xf8f8f8);
            [topicsBtn setTitleColor:UIColorFromRGB(0x5d5d5d) forState:UIControlStateNormal];
            topicsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            topicsBtn.frame = CGRectMake(j*(btnWidth+8)+ViewSpace,self.thehieght+topicsLabel.frame.size.height+ i*(btnHeight+8), btnWidth, btnHeight);
            topicsBtn.tag = 200+i*2+j;
            [topicsBtn setTitle:topicsTitle forState:UIControlStateNormal];
            [topicsBtn addTarget:self action:@selector(clickTopicBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:topicsBtn];
        }
        
    }
    self.thehieght+=(CGRectGetHeight(topicsLabel.frame) +btnHeight*lines+8*(lines-1));
    
}
- (NSString *)changeRankNameWithType:(NSString *)rankType
{
    NSString *rankName = @"";
    if ([rankType isEqualToString:@"power"]) {
        rankName = @"舔力榜";
    }else if ([rankType isEqualToString:@"god"])
    {
        rankName = @"舔神榜";
    }else if ([rankType isEqualToString:@"star"])
    {
        rankName = @"明星榜";
    }else if ([rankType isEqualToString:@"topic"])
    {
        rankName = @"话题榜";
    }
    return rankName;
}
- (void)addRankView
{
    CGFloat myTopicBtnWidth = SCREEN_SIZE.width*70/375;
    CGFloat myTopicBtnHeight = myTopicBtnWidth*184/140;
    
    UIButton *myTopicBtn ;
    SETIMAGEBTN(myTopicBtn, @"", @"");
    myTopicBtn.backgroundColor = UIColorFromRGB(0xf8f8f8);
    myTopicBtn.frame = CGRectMake(ViewSpace, self.thehieght+5, myTopicBtnWidth, myTopicBtnHeight);
    [myTopicBtn addTarget:self action:@selector(clickMyTopicBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:myTopicBtn];
    
    UIImageView *myTopicLogoImageV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, myTopicBtnWidth - 16, myTopicBtnWidth - 16)];
    myTopicLogoImageV.image = UIIMAGE(@"myTopicLogo");
    [myTopicBtn addSubview:myTopicLogoImageV];
    
    [myTopicBtn setTitleColor:UIColorFromRGB(0x5d5d5d) forState:UIControlStateNormal];
    [myTopicBtn setTitle:@"我的话题" forState:UIControlStateNormal];
    myTopicBtn.titleEdgeInsets = UIEdgeInsetsMake(myTopicBtnWidth-8, 0, 0, 0);
    myTopicBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    CGFloat rankBtnWidth = (SCREEN_SIZE.width - myTopicBtnWidth - 2*ViewSpace -8*2)/2.0f;
    CGFloat rankBtnHeight = (myTopicBtnHeight - 8)/2.0f;
    
    NSArray *rangArray = self.hotLicksinfo.ranks;
    for (int i=0; i<2; i++) {
        for (int j=0; j<2; j++) {
            if (i*2+j>=rangArray.count) {
                break;
            }
            XTHotLicksRankInfo *rankInfo = [rangArray objectAtIndex:i*2+j];
            UIButton *rankBtn ;
            SETIMAGEBTN(rankBtn, @"", @"");
            rankBtn.backgroundColor = UIColorFromRGB(0xf8f8f8);
            rankBtn.frame = CGRectMake(ViewSpace +myTopicBtnWidth + 8 +j*(rankBtnWidth+8), self.thehieght+5 +i*(rankBtnHeight+8), rankBtnWidth, rankBtnHeight);
            rankBtn.tag = 300+i*2+j;
            [rankBtn addTarget:self action:@selector(clickRankBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:rankBtn];
            UIImageView *rankBtnLeftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, rankBtnHeight-6, rankBtnHeight-6)];
            CHANGETOFILLET(rankBtnLeftImageV);
            [rankBtnLeftImageV an_setImageWithURL:rankInfo.headImg placeholderImage:nil];
            [rankBtn addSubview:rankBtnLeftImageV];
            
            //  [rankBtnLeftImageV sd_setImageWithURL:<#(NSURL *)#> placeholderImage:nil];
            UILabel *rankBtnlabel = [[UILabel alloc]initWithFrame:CGRectMake(rankBtnLeftImageV.frame.size.width+3, 0, rankBtnWidth - rankBtnLeftImageV.frame.size.width - 3*2, rankBtnHeight)];
            
            
            rankBtnlabel.text = [self changeRankNameWithType:rankInfo.type];
            rankBtnlabel.textAlignment = NSTextAlignmentCenter;
            rankBtnlabel.contentMode = UIViewContentModeCenter;
            rankBtnlabel.font = [UIFont systemFontOfSize:12];
            rankBtnlabel.textColor = UIColorFromRGB(0x5d5d5d);
            [rankBtn addSubview:rankBtnlabel];
            
            
        }
    }
    
    self.thehieght+=(myTopicBtnHeight+5);
}
- (void)addImageLabel
{
    UILabel *imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(ViewSpace, self.thehieght, 150, 26)];
    imageLabel.text = @"话题精选图片:";
    imageLabel.font = [UIFont systemFontOfSize:11];
    imageLabel.textColor = UIColorFromRGB(0x7f7f7f);
    [self addSubview:imageLabel];
    
    self.thehieght +=imageLabel.frame.size.height;
    CLog(@"headerview的高度是=%f",self.thehieght);
}



#pragma mark - clickBtnActions

- (void)clickBannerBtnAction
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickBannerBtn)]) {
        [self.delegate clickBannerBtn];
    }
}
- (void)clickMyTopicBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMyTopicBtn)]) {
        [self.delegate clickMyTopicBtn];
    }
}
- (void)clickRankBtnAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRankBtn:)]) {
        [self.delegate clickRankBtn:sender];
    }
    
}
- (void)clickTopicBtnAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickTopicBtn:)]) {
        [self.delegate clickTopicBtn:sender];
    }
}

#pragma mark - collectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.hotLicksinfo.recs.count>=18?18:self.hotLicksinfo.recs.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTHotLicksHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenstr forIndexPath:indexPath];
    XTHotLicksRecsInfo *tempRecsInfo = [self.hotLicksinfo.recs objectAtIndex:indexPath.row];
    cell.descriptionLabel.text = tempRecsInfo.title;
    if ([tempRecsInfo.type isEqualToString:@"more"]) {
        [cell.imgView setImage:UIIMAGE(@"review")];
    }else
    {
        NSString *placeholderImgae = [NSString stringWithFormat:@"placeholderImage%zd",indexPath.row%6+1];
    [cell.imgView an_setImageWithURL:tempRecsInfo.cover placeholderImage:UIIMAGE(placeholderImgae)];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRecsWithIndex:)]) {
        [self.delegate clickRecsWithIndex:indexPath.row];
    }
//    CLog(@"clickCollectionIndex = %d",indexPath.row);
}

#pragma mark - scrollview Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int curpage = floor((scrollView.contentOffset.x)/(SCREEN_SIZE.width-17));
//    CLog(@"crupage===%d",curpage);
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%ld",curpage+1,[self getThePageCount]];
}
- (long)getThePageCount
{
    long a = self.hotLicksinfo.recs.count/6;
    int b = self.hotLicksinfo.recs.count%6;
    if (b>0) {
        a+=1;
    }
    return a;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
