//
//  XTUserAlbumInfo.h
//  StarPicture
//
//  Created by 曹亚云 on 15-3-7.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Mantle.h>
typedef NS_ENUM(NSInteger, AlbumType) {
    AlbumTypePublic, //公开类型
    AlbumTypeSecret, //私密类型
};

@interface XTUserAlbumInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) AlbumType type;
@property (nonatomic, strong) NSString *albumID;
@property (nonatomic, strong) NSString *albumTitle;
@property (nonatomic, strong) NSString *imageCount;
@property (nonatomic, retain) NSURL *coverImageURL;

@end
