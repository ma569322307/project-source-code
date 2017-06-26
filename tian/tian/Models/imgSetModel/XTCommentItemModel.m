//
//  XTCommentItemModel.m
//  tian
//
//  Created by loong on 15/6/30.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTCommentItemModel.h"
#import "XTUserInfo.h"

@interface XTCommentItemModel ()

@property(nonatomic,strong)NSNumber *dateCreated;

@property(nonatomic, copy)NSString *content;

@property(nonatomic)BOOL commended;


@end

@implementation XTCommentItemModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"itemID":@"id",@"originalCommentNickName":@"originalComment.user.nickName"};
}


+ (NSValueTransformer *)userJSONTransformer{
    
    return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *dic) {
        NSError *error = nil;
        XTUserInfo *user = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:dic error:&error];
        return user;
    }];
}

- (void)setDateCreated:(NSNumber *)dateCreated {
    self.createdAt = dateCreated;
}

- (void)setContent:(NSString *)content {
    self.text = content;
}

-(void)setCommended:(BOOL)commended{
    self.supported = commended;
}

@end
