//
//  XTUserFilesInfo.h
//  tian
//
//  Created by 曹亚云 on 15-6-12.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "MTLModel.h"

@interface XTUserFilesInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *userID;         //用户编号
@property (nonatomic, strong) NSURL *headImg;           //用户头像
@property (nonatomic, strong) NSString *nickName;       //用户昵称
@property (nonatomic, strong) NSString *renownCount;    //粉丝声望值
@property (nonatomic, strong) NSString *renownToday;    //粉丝今日获得声望
@property (nonatomic, strong) NSString *creditsCount;   //粉丝积分值
@property (nonatomic, strong) NSString *creditsToday;   //粉丝今日获得积分
@property (nonatomic, strong) NSString *gender;         //粉丝性别
@property (nonatomic, strong) NSString *age;            //粉丝年龄
@property (nonatomic, strong) NSString *star;           //粉丝星座
@property (nonatomic, strong) NSString *province;       //粉丝所在省
@property (nonatomic, strong) NSString *city;           //粉丝所在市
@property (nonatomic, strong) NSString *qingGan;        //粉丝情感
@property (nonatomic, strong) NSString *brief;          //粉丝签名
@property (nonatomic, strong) NSString *beiZhu;         //粉丝其它属性
@end
