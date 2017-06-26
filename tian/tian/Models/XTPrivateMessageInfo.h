//
//  XTPrivateMessageInfo.h
//  StarPicture
//
//  Created by cc on 15-3-10.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTPrivateMessageInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) long id;
@property (nonatomic, assign) long from;
@property (nonatomic, assign) long to;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString * createAt;


//@property (nonatomic, strong) NSString *image;
//@property (nonatomic, strong) NSString *audioUrl;
//@property (nonatomic, assign) NSInteger audioDuration;


@end
