//
//  XTUserFriendTrendsInfo.h
//  StarPicture
//
//  Created by 曹亚云 on 15-3-11.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Mantle.h>

@interface XTUserFriendTrendsInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) long long createTime;
@property (nonatomic, strong) NSString *infoID;
@property (nonatomic, strong) NSString *imageDesc;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, retain) NSURL *thumbnailPicURL;
@property (nonatomic, strong) NSDictionary *user;


@end
