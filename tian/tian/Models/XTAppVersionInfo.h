//
//  XTAppVersionInfo.h
//  StarPicture
//
//  Created by cc on 15-3-16.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface XTAppVersionInfo : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString * currentVersion;//当前版本
@property (nonatomic, strong) NSString * appNewVersion;//最新版本
@property (nonatomic, strong) NSURL * appUrl;//应用更新url
@property (nonatomic, strong) NSString * updateStrategy;//更新等级
@property (nonatomic, strong) NSString * message;//更新提示信息
@end
