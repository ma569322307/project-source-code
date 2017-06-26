//
//  XTTopicExampleCell.m
//  tian
//
//  Created by yyt on 15/6/23.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTopicListCell.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTTopicListModel.h"
#import "YYTAlertView.h"
#import "XTTopicListViewController.h"
#define K_COLLECTIONWITHTOPIC @"http://papi.yinyuetai.com/topic/favorites/add.json"//收藏话题的借口
#define K_DELETETOPIC @"topic/favorites/delete.json"//删除收藏话题的借口

@interface XTTopicListCell ()
@property (nonatomic, strong) XTTopicListModel *topicListModel;
@property (nonatomic, assign) NSInteger collectTopicId;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@end

@implementation XTTopicListCell

- (void)awakeFromNib {
}
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xd2d2d2).CGColor);
    CGContextSetLineWidth(context, 0.5f);
    
    CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(context);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)configWithTopicCell:(XTTopicListModel *)model{
    
    self.topicListModel = model;
    
    [self.HeadImageView an_setImageWithURL:[NSURL URLWithString:self.topicListModel .cover] placeholderImage:nil];
    self.contentLable.text = self.topicListModel .content;
    self.topicId = self.topicListModel .topicId;
    self.titleLable.text = [NSString stringWithFormat:@"%@",self.topicListModel.title];
    self.hotValueLable.text = [NSString stringWithFormat:@"热度值:%@",@(self.topicListModel .score)];
    if (self.topicListModel .favorited == YES) {
        [self.FavoritesButton setBackgroundImage:[UIImage imageNamed:@"HotLicks_collect_sel"] forState:UIControlStateNormal];
    }else{
        [self.FavoritesButton setBackgroundImage:[UIImage imageNamed:@"HotLicks_collect"] forState:UIControlStateNormal];
    }
    self.collectTopicId = model.topicId;
}

- (IBAction)FavoritesButton:(UIButton *)sender and:(NSIndexPath *)index {
    if (self.topicListModel.favorited == NO) {
                self.topicListModel.favorited = !self.topicListModel.favorited;
                if (self.topicListModel.favorited == YES) {
                    [self CollectWithTopic];
               [self.FavoritesButton setBackgroundImage:[UIImage imageNamed:@"HotLicks_collect_sel"] forState:UIControlStateNormal];
                }
    }else{
                self.topicListModel.favorited = !self.topicListModel.favorited;
                if (self.topicListModel.favorited == NO) {
                    [self deleteWithTopic];
                    [self.FavoritesButton setBackgroundImage:[UIImage imageNamed:@"HotLicks_collect"] forState:UIControlStateNormal];
                }
    }
}
//收藏话题
-(void)CollectWithTopic{
    NSDictionary *dic = @{@"topicId":[NSString stringWithFormat:@"%ld",self.collectTopicId]};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:K_COLLECTIONWITHTOPIC parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"收藏成功" withCompletionBlock:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"收藏失败" withCompletionBlock:nil];

    }];
}
//删除话题
-(void)deleteWithTopic{
    NSDictionary *paramDic = @{@"topicId":[NSString stringWithFormat:@"%ld",self.collectTopicId]};
    
    XTHTTPRequestOperationManager *Manager = [XTHTTPRequestOperationManager sharedManager];
    [Manager POST:K_DELETETOPIC parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"取消收藏成功" withCompletionBlock:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"取消收藏失败" withCompletionBlock:nil];
    }];
}
@end
