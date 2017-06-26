//
//  XTTagInfo.m
//  tian
//
//  Created by huhuan on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTagInfo.h"

@interface XTTagInfo()

@property(nonatomic)NSInteger objId;

@property(nonatomic,strong)NSString *type;

@end


@implementation XTTagInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tagId" : @"id"
             };
}



-(void)setObjId:(NSInteger)aObjId{
    self.tagId = aObjId;
}


-(void)setType:(NSString *)aType{
    if ([aType isEqualToString:@"artist"]) {
        self.tagType = XTTagArtist;
    }else if ([aType isEqualToString:@"str"]){
        self.tagType = XTTagNormal;
    }
}

@end
