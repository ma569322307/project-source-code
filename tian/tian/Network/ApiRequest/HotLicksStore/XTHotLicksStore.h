//
//  XTHotLicksStore.h
//  tian
//
//  Created by cc on 15/5/26.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTHotLicksInfo.h"
@interface XTHotLicksStore : NSObject
/**
 *   热舔数据
 */
- (id)fetchHotLicksInfoCompletionBlock:(void(^)(id hotLickInfo, NSError *error))block;
- (id)fetchShowPicWithRecId:(NSInteger)recid offset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id hotLickInfo, NSError *error))block;
/**
 *   热门帖子
 */
- (id)fetchHotTopicListWithoffset:(NSInteger)offset size:(NSInteger)size CompletionBlock:(void(^)(id hotLickInfo, NSError *error))block;
@end
