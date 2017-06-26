//
//  XTLickGodStore.h
//  tian
//
//  Created by cc on 15/6/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTLickGodStore : NSObject
//舔神属性
- (id)fetchGodPropsWithOffset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id hotLickInfo, NSError *error))block;
//舔神首页推荐图片
- (id)fetchGodPicsWithUserId:(NSInteger)uid offset:(NSInteger)offset size:(NSInteger)size fromId:(NSInteger)lastAlbumId CompletionBlock:(void(^)(id hotLickInfo, NSError *error))block;
//舔神分类
- (id)fetchGodPictureListWithPropId:(NSInteger)propId offset:(NSInteger)offset size:(NSInteger)size fromId:(NSInteger)lastAlbumId CompletionBlock:(void(^)(id hotLickInfo, NSError *error))block;
@end
