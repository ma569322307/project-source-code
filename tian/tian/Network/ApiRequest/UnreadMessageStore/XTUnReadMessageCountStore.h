//
//  XTUnReadMessageCountStore.h
//  StarPicture
//
//  Created by cc on 15-3-31.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTUnReadInfo.h"
#define UnReadCount_key @"remind/unread/count.json"
#define kUnReadCountKey @"unReadCount"
#define kNotificationkey   @"notification"
#define kMessagekey        @"Message"

@interface XTUnReadMessageCountStore : NSObject
@property (nonatomic, strong) XTUnReadInfo *unreadInfo;
- (id)fetchUnReadMessageCount;
+(XTUnReadMessageCountStore*)getInstance;
@end
